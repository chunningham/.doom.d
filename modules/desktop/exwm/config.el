;;; desktop/exwm/config.el -*- lexical-binding: t; -*-

(defun exwm-change-screen-hook ()
  (interactive)
  (let ((xrandr-output-regexp "\n\\([^ ]+\\) connected ")
        default-output)
    (with-temp-buffer
      (call-process "xrandr" nil t nil)
      (goto-char (point-min))
      (re-search-forward xrandr-output-regexp nil 'noerror)
      (setq default-output (match-string 1))
      (forward-line)
      (if (not (re-search-forward xrandr-output-regexp nil 'noerror))
          (call-process "xrandr" nil nil nil "--auto")
        (call-process
         "xrandr" nil nil nil
         "--output" (match-string 1) "--primary" "--auto"
         "--output" default-output "--below" (match-string 1))
        (setq exwm-randr-workspace-output-plist
              (list 0 default-output
                    1 (match-string 1)))))))

;; (load! "+posframe")
;; (load! "+volume")

(defun cc/exwm-app-launcher ()
  "Launches an application in your PATH.
Can show completions at point for COMMAND using helm or ido"
  (interactive)
  (unless dmenu--cache-executable-files
    (dmenu--cache-executable-files))
  (ivy-read "Run a command: " dmenu--cache-executable-files
            :action (lambda (command) (start-process-shell-command command nil command))
            :caller 'cc/exwm-app-launcher))

(defun cc/run-or-raise (NAME PROGRAM)
  (interactive)
  (let ((buf (cl-find-if
              (lambda (buf) (string= NAME (buffer-name buf)))
              (buffer-list))))

    (if buf (switch-to-buffer buf)
      (start-process NAME nil "setsid" "-w" PROGRAM))))

(defun cc/shell-cmd (command)
  `(lambda ()
     (interactive)
     (start-process-shell-command ,command nil ,command)))

(battery) ; initializes battery-status-function
(run-at-time nil 60 #'cc/check-battery)
(require 'notifications)
(defun cc/check-battery ()
  "Checks battery level and makes a warning if it is too low."
  (let* ((status (funcall battery-status-function))
         (charging (string-equal (alist-get ?B status) "Charging"))
         (remain (string-to-number (alist-get ?p status))))

    (if (and (not charging) (< remain 15))
        (notifications-notify :body "Battery too low! Please charge now!" :urgency 'critical))))

;; props to https://github.com/ch11ng/exwm/issues/593
(defun my-exwm-workspace-switch-to-buffer (orig-func buffer-or-name &rest args)
  (when buffer-or-name
    (if (and (get-buffer buffer-or-name)
             (or exwm--floating-frame
                 (with-current-buffer buffer-or-name exwm--floating-frame)))
        (exwm-workspace-switch-to-buffer buffer-or-name)
      (apply orig-func buffer-or-name args))))

(use-package! dmenu)
;; (use-package! gpastel)
;; (use-package! exwm-mff)
(use-package! xelb)

(use-package! exwm
  :commands (exwm-enable exwm-init)
  ;; :hook (exwm-init . exwm-mff-mode)
  ;; :hook (exwm-mode . doom-mark-buffer-as-real-h)

  :init
  (set-popup-rule! "^\\*EXWM\\*$" :ignore t)
  ;; (load! "+polybar")

  ;; (add-hook! 'exwm-init-hook 'gpastel-start-listening)

  ;; (require 'exwm-systemtray)
  ;; (exwm-systemtray-enable)
  ;; (setq mouse-autoselect-window t
  ;;       focus-follows-mouse t)

  :config
;;  (load! "+brightness")

  (advice-add 'switch-to-buffer :around 'my-exwm-workspace-switch-to-buffer)
  (advice-add 'ivy--switch-buffer-action :around 'my-exwm-workspace-switch-to-buffer)

  (defun my/exwm-counsel-yank-pop ()
    "Same as `counsel-yank-pop' and paste into exwm buffer."
    (interactive)
    (let ((inhibit-read-only t)
          ;; Make sure we send selected yank-pop candidate to
          ;; clipboard:
          (yank-pop-change-selection t))
      (call-interactively #'counsel-yank-pop))
    (when (derived-mode-p 'exwm-mode)
      ;; https://github.com/ch11ng/exwm/issues/413#issuecomment-386858496
      (exwm-input--set-focus (exwm--buffer->id (window-buffer (selected-window))))
      (exwm-input--fake-key ?\C-v)))

  ;; Disable dialog boxes since they are unusable in EXWM
  (setq use-dialog-box nil)

  ;; You may want Emacs to show you the time
  ;; (display-time-mode t)
  ;; (setq display-time-24hr-format t)
  ;; (setq-default display-time-format "%H:%M")
  ;; (setq display-time-default-load-average nil)

 ;;(add-to-list 'evil-emacs-state-modes 'exwm-mode)
  (add-hook 'exwm-mode-hook 'evil-emacs-state)
  (add-hook 'exwm-mode-hook 'hide-mode-line-mode)

  ;; All buffers created in EXWM mode are named "*EXWM*". You may want to change
  ;; it in `exwm-update-class-hook' and `exwm-update-title-hook', which are run
  ;; when a new window class name or title is available. Here's some advice on
  ;; this subject:
  ;; + Always use `exwm-workspace-rename-buffer` to avoid naming conflict.
  ;; + Only renaming buffer in one hook and avoid it in the other. There's no
  ;;   guarantee on the order in which they are run.
  ;; + For applications with multiple windows (e.g. GIMP), the class names of all
  ;;   windows are probably the same. Using window titles for them makes more
  ;;   sense.
  ;; + Some application change its title frequently (e.g. browser, terminal).
  ;;   Its class name may be more suitable for such case.
  ;; In the following example, we use class names for all windows expect for
  ;; Java applications and GIMP.
  (add-hook 'exwm-update-class-hook
            (lambda ()
              (unless (or (string-prefix-p "sun-awt-X11-" exwm-instance-name)
                          (string= "qutebrowser" exwm-class-name)
                          (string= "gimp" exwm-instance-name))
                (exwm-workspace-rename-buffer exwm-class-name))))

  (add-hook 'exwm-update-title-hook
            (lambda ()
              (when (or (not exwm-instance-name)
                        (string-prefix-p "sun-awt-X11-" exwm-instance-name)
                        (string= "qutebrowser" exwm-class-name)
                        (string= "gimp" exwm-instance-name))
                (exwm-workspace-rename-buffer exwm-title))))

  ;; Quick swtiching between workspaces
  (defvar exwm-toggle-workspace 0
    "Previously selected workspace. Used with `exwm-jump-to-last-exwm'.")

  (defun exwm-jump-to-last-exwm ()
    (interactive)
    (exwm-workspace-switch exwm-toggle-workspace))

  (defadvice exwm-workspace-switch (before save-toggle-workspace activate)
    (setq exwm-toggle-workspace exwm-workspace-current-index))

  ;; + Set shortcuts to switch to a certain workspace.
  (dotimes (i 10)
    (exwm-input-set-key (kbd (format "s-%d" i))
                        `(lambda ()
                           (interactive)
                           (exwm-workspace-switch-create ,i))))

  (when (featurep! :app telega +ivy)
    (exwm-input-set-key (kbd "s-i") #'cc/sauron-show))

  (setq exwm-input-prefix-keys
        '(?\C-\\                        ; xim
          ?\C-x
          ?\M-x
          ?\M-m
          ?\C-g
          ?\C-m
          ?\C-h
          ?\C-р                         ; cyrillic
          ))

  (require 'exwm-xim)
  (exwm-xim-enable)

  (define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)
  (define-key exwm-mode-map [?\C-c] 'nil)

  ;; Undo window configurations


  (setq exwm-layout-show-all-buffers t
        exwm-workspace-show-all-buffers t)

  (require 'exwm-randr)
  ;; (setq exwm-randr-workspace-output-plist '(0 "VGA1"))
  (add-hook 'exwm-randr-screen-change-hook #'exwm-change-screen-hook)
  (exwm-randr-enable)
  ;; The following example demonstrates how to use simulation keys to mimic the
  ;; behavior of Emacs. The argument to `exwm-input-set-simulation-keys' is a
  ;; list of cons cells (SRC . DEST), where SRC is the key sequence you press and
  ;; DEST is what EXWM actually sends to application. Note that SRC must be a key
  ;; sequence (of type vector or string), while DEST can also be a single key.

  (exwm-input-set-simulation-keys
   (mapcar (lambda (c) (cons (kbd (car c)) (cdr c)))
           '(
             ;; ("C-b" . left)
             ;; ("C-f" . right)
             ;; ("C-p" . up)
             ("C-m" . return)
             ;; ("C-n" . down)
             ("DEL" . backspace)
             ("C-р" . backspace)
             )))

  (exwm-input-set-key (kbd "s-.") (lambda () (interactive) (message "%s %s"
                                                               (concat (format-time-string "%Y-%m-%d %T (%a w%W)"))
                                                               (battery-format "| %L: %p%% (%t)" (funcall battery-status-function)))))

  ;; (exwm-input-set-simulation-keys nil)

  ;; Do not forget to enable EXWM. It will start by itself when things are ready.
  (exwm-enable)
  )

(use-package! exwm
  ;; :hook doom-mark-buffer-as-real-h
  :config
  (use-package! exwm-randr
    :hook (exwm-randr-screen-change . (lambda ()
                                        (start-process-shell-command
                                         "xrandr" nil "xrandr --output DP1 --mode 3840x2160 --above eDP1")))
    :config
    (setq exwm-randr-workspace-monitor-plist '(0 "eDP1" 1 "DP1"))
    (exwm-randr-enable))

  (use-package! desktop-environment)

  (use-package! gpastel
    :config
    (gpastel-mode)
    (defun my/exwm-counsel-yank-pop ()
      "Same as 'counsel-yank-pop' and paste into exwm buffer."
      (interactive)
      (let ((inhibit-read-only t)
            ;; Make sure we send selected yank-pop candidate to clipboard:
            (yank-pop-change-selection t))
        (call-interactively #'counsel-yank-pop))
      (when (derived-mode-p 'exwm-mode)
        (exwm-input--set-focus (exwm--buffer->id (window-buffer (selected-window))))
        (exwm-input--fake-key ?\C-v))))

  (unless (get 'exwm-workspace-number 'saved-value)
    (setq exwm-workspace-number 4))

  ;; Make class name the buffer name
  (add-hook 'exwm-update-class-hook
            (lambda ()
              (exwm-workspace-rename-buffer exwm-class-name)))

  (general-simulate-key "SPC" :state 'normal)

  (defun my/press-leader-key ()
    "Activate the evil leader keymap"
    (interactive)
    (general-simulate-SPC-in-normal-state))

  (setq lsp-keymap-prefix "s-M-C-<return>")

  ;; Global keybindings.
  (unless (get 'exwm-input-global-keys 'saved-value)
    (setq exwm-input-global-keys
          `(
            ;; 's-r': Reset (to line-mode).
            (,(kbd "s-r") . exwm-reset)
            ;; 's-w': Switch workspace.
            (,(kbd "s-w") . exwm-workspace-switch)
            ;; 's-W': Move buffer to workspace
            (,(kbd "s-W") . exwm-workspace-move-window)
            ;; 's-p': paste.
            (,(kbd "s-p") . my/exwm-counsel-yank-pop)
            ;; s-y': copy.
            ;; (,(kbd "s-y") . )
            ;; 's-d': Launch application.
            (,(kbd "s-d") . counsel-linux-app)
            ;; 's-b': change buffer.
            (,(kbd "s-b") . counsel-switch-buffer)
            ;; 's-f': open file.
            (,(kbd "s-f") . counsel-find-file)
            ;; 's-q': Kill window.
            (,(kbd "s-q") . evil-window-delete)
            ;; 's-Q': Kill buffer.
            (,(kbd "s-Q") . kill-this-buffer)
            ;; 's-M-q': Kill window and buffer
            (,(kbd "s-M-q") . kill-buffer-and-window)
            ;; 's-x': org-capture
            (,(kbd "s-x") . org-capture)
            ;; 's-a': org-agenda
            (,(kbd "s-a") . org-agenda)
            ;; 's-`': previous buffer
            (,(kbd "s-`") . evil-switch-to-windows-last-buffer)
            ;; 's-m': maximize window
            (,(kbd "s-m") . doom/window-maximize-buffer)
            ;; 's-s': Split Vertically
            (,(kbd "s-s") . evil-window-vsplit)
            ;; 's-S': Split Horizontally
            (,(kbd "s-S") . evil-window-split)
            ;; 's-u': winner-undo
            (,(kbd "s-u") . winner-undo)
            ;; 's-t': popup terminal
            (,(kbd "s-t") . +vterm/toggle)
            ;; 's-T': terminal in this window
            (,(kbd "s-T") . +vterm/here)
            ;; 's-N': Switch to certain workspace.
            ,@(mapcar (lambda (i)
                        `(,(kbd (format "s-%d" i)) .
                          (lambda ()
                            (interactive)
                            (exwm-workspace-switch-create ,i))))
                      (number-sequence 0 9))
            ;; s-hjkl: navigate windows
            (,(kbd "s-h") . evil-window-left)
            (,(kbd "s-j") . evil-window-down)
            (,(kbd "s-k") . evil-window-up)
            (,(kbd "s-l") . evil-window-right)

            ;; s-HJKL: move windows
            (,(kbd "s-H") . +evil/window-move-left)
            (,(kbd "s-J") . +evil/window-move-down)
            (,(kbd "s-K") . +evil/window-move-up)
            (,(kbd "s-L") . +evil/window-move-right)

            ;; s-M-hjkl: resize windows
            (,(kbd "s-M-h") . evil-window-decrease-width)
            (,(kbd "s-M-j") . evil-window-decrease-height)
            (,(kbd "s-M-k") . evil-window-increase-height)
            (,(kbd "s-M-l") . evil-window-increase-width)

            ;; Brightness
            (,(kbd "<XF86MonBrightnessUp>") . ,(function desktop-environment-brightness-increment))
            (,(kbd "<XF86MonBrightnessDown>") . ,(function desktop-environment-brightness-decrement))
            (,(kbd "S-<XF86MonBrightnessUp>") . ,(function desktop-environment-brightness-increment-slowly))
            (,(kbd "S-<XF86MonBrightnessDown>") . ,(function desktop-environment-brightness-decrement-slowly))

            ;; Volume
            (,(kbd "<XF86AudioRaiseVolume>") . ,(function desktop-environment-volume-increment))
            (,(kbd "<XF86AudioLowerVolume>") . ,(function desktop-environment-volume-decrement))
            (,(kbd "S-<XF86AudioRaiseVolume>") . ,(function desktop-environment-volume-increment-slowly))
            (,(kbd "S-<XF86AudioLowerVolume>") . ,(function desktop-environment-volume-decrement-slowly))
            (,(kbd "<XF86AudioMute>") . ,(function desktop-environment-toggle-mute))

            ;; (,(kbd "<XF86AudioMicMute>") . ,(function desktop-environment-toggle-microphone-mute))
            ;; (,(kbd "S-<print>") . ,(function desktop-environment-screenshot-part))
            ;; (,(kbd "<print>") . ,(function desktop-environment-screenshot))
            ;; Screen locking
            ;; (,(kbd "s-l") . ,(function desktop-environment-lock-screen))
            ;; Wifi controls
            ;; (,(kbd "<XF86WLAN>") . ,(function desktop-environment-toggle-wifi))
            ;; Bluetooth controls
            ;; (,(kbd "<XF86Bluetooth>") . ,(function desktop-environment-toggle-bluetooth))
            )
          ))
  ;; Line-editing shortcuts
  (unless (get 'exwm-input-simulation-keys 'saved-value)
    (setq exwm-input-simulation-keys
          '()))

  ;; Enable EXWM
  ;; (exwm-enable)
  )
