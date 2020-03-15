;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;; This emacs was installed via:
;; brew tap daviderestivo/emacs-head
;; brew install emacs-head --HEAD --with-cocoa --with-dbus --with-imagemagick
;; --with-jansson --with-mailutils --with-pdumper

(setq doom-theme 'doom-molokai)

(setq user-full-name "Charles Cunningham"
      user-mail-address "c.a.cunningham6@gmail.com")

(setq deft-directory org-directory)

(after! calender
  (setq org-gcal-client-id "509352370358-o1j21kpjvjjs15iek9p7ocnv63f24oqc.apps.googleusercontent.com"
        org-gcal-client-secret "Olqey39CAUc_Pc_xy_Og89W0"
        org-gcal-file-alist '(("c.a.cunningham6@gmail.com" . "~/org/schedule.org")
                              ("hildebrand.me_ol6c9vukg2dlh3vm4u58vhjp94@group.calendar.google.com" . "~/org/schedule.org"))))

(defun my-open-calender ()
  (interactive)
  (cfw:open-calendar-buffer
   :contents-sources
   (list
    (cfw:org-create-source "Green")  ; orgmode source
    ;;(cfw:howm-create-source "Blue")  ; how source
    ;;(cfw:cal-create-source "Orange") ; diary source
    ;;(cfw:ical-create-source "Moon" "~/moon.ics" "Gray")  ; ICS source1
    ;;(cfw:ical-create-source "gcal" "https://..../basic.ics" "IndianRed") ; google calendar ICS
    )))

(display-time)
(display-battery-mode)

(use-package! smart-mode-line
  :config
  (sml/setup)
  (setq sml/theme 'dark
        rm-whitelist '(yas)))

(use-package! mini-modeline
  :after smart-mode-line
  :config (mini-modeline-mode t))

(use-package! which-key-posframe
  :config
  (which-key-posframe-mode)
  (setq which-key-posframe-parameters '((min-width . 90) (min-height . 5) (parent-frame . nil)))
  )

(use-package! exwm
  ;; :hook (exwm-mode . doom-mark-buffer-as-real)
  :config
  (use-package! exwm-randr
    :hook (exwm-randr-screen-change . (lambda ()
                                        (start-process-shell-command
                                         "xrandr" nil "xrandr --output DP1 --mode 3840x2160 --above eDP1")))
    :config
    (setq exwm-randr-workspace-monitor-plist '(0 "eDP1" 1 "DP1"))
    (exwm-randr-enable))

  (use-package! desktop-environment)

  (unless (get 'exwm-workspace-number 'saved-value)
    (setq exwm-workspace-number 4))

  ;; Make class name the buffer name
  (add-hook 'exwm-update-class-hook
            (lambda ()
              (exwm-workspace-rename-buffer exwm-class-name)))

  ;; Global keybindings.
  (unless (get 'exwm-input-global-keys 'saved-value)
    (setq exwm-input-global-keys
          `(
            ;; 's-r': Reset (to line-mode).
            (,(kbd "s-r") . exwm-reset)
            ;; 's-w': Switch workspace.
            (,(kbd "s-w") . exwm-workspace-switch)
            ;; 's-d': Launch application.
            (,(kbd "s-d") . (lambda (command)
                              (interactive (list (read-shell-command "$ ")))
                              (start-process-shell-command command nil command)))
            ;; 's-,': change buffer.
            (,(kbd "s-,") . counsel-switch-buffer)
            ;; 's-.': open file.
            (,(kbd "s-.") . counsel-find-file)
            ;; 's-q': Kill window.
            (,(kbd "s-q") . evil-window-delete)
            ;; 's-Q': Kill window and buffer.
            (,(kbd "s-Q") . kill-buffer-and-window)
            ;; 's-s': Split Vertically
            (,(kbd "s-s") . evil-window-vsplit)
            ;; 's-S': Split Horizontally
            (,(kbd "s-S") . evil-window-split)
            ;; 's-RET': popup terminal TODO: broken
            (,(kbd "s-RET") . +vterm/toggle)
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
            ;; s-SPC: global leader key
            ;; (,(kbd "s-SPC") . )
            )
          ))
  ;; Line-editing shortcuts
  (unless (get 'exwm-input-simulation-keys 'saved-value)
    (setq exwm-input-simulation-keys
          '(([?\C-b] . [left])
            ([?\C-f] . [right])
            ([?\C-p] . [up])
            ([?\C-n] . [down])
            ([?\C-a] . [home])
            ([?\C-e] . [end])
            ([?\M-v] . [prior])
            ([?\C-v] . [next])
            ([?\C-d] . [delete])
            ([?\C-k] . [S-end delete]))))

  ;; Enable EXWM
  (exwm-enable)
  )

;; (load-file "~/.doom.d/hydras.el")
;; (setq hydra-hint-display-type 'posframe)
(after! ivy
  (setq ivy-posframe-parameters '((min-width . 90) (min-height . 17) (parent-frame . nil)))
  )



(after! objed
  ;; create leader key
  (define-key objed-map (kbd "SPC") 'hydra-hail/body)
  (define-key objed-map (kbd "M-x") 'counsel-M-x)

  ;; set S-SPC to toggle objed mode
  (define-key objed-map (kbd "S-SPC") 'objed-quit)
  (define-key global-map (kbd "S-SPC") 'objed-activate)
  (setq-default cursor-type 'bar)
  )

(after! company
  (define-key company-active-map (kbd "RET") 'company-complete-selection)
  )

(after! org
  (setq org-todo-keywords
        '((sequence
           "TODO(t)"   ; A task that needs doing & is ready to do
           "PROJ(p)"   ; An ongoing project that cannot be completed in one step
           "STRT(s)"   ; A task that is in progress
           "WAIT(w@)"  ; Something is holding up this task; or it is paused
           "|"
           "DONE(d!)"   ; Task successfully completed
           "KILL(k@)")  ; Task was cancelled, aborted or is no longer applicable
          (sequence
           "[ ](T)"                     ; A task that needs doing
           "[-](S)"                     ; Task is in progress
           "[?](W)"                     ; Task is being held up or paused
           "|"
           "[X](D)"))                   ; Task was completed
        org-capture-templates
        '(("j" "Journal" entry
           (file+olp+datetree "journal.org" "Inbox")
           "* %U %?\n%i" :prepend t)
          ("i" "Inbox" entry
           (file "inbox.org")
           "* TODO %i%?\n%a\n")
          ("T" "Tickler" entry
           (file "tickler.org")
           "* %i%?\n%U")
          ("c" "Current Task Note" entry
           (clock)
           "* %i%?\n%a")
          ("p" "Project todo" entry
           (file+function "projects.org" projectile-project-name)
           "* TODO %?\n %i\n %a")
          ("b" "Brain" plain
           (function org-brain-goto-end)
           "* %i%?" :empty-lines 1))
        org-refile-targets
        '(("inbox.org" :maxlevel . 2)
          ("projects.org" :maxlevel . 3)
          ("someday.org" :level . 1)
          ("tickler.org" :maxlevel . 2))
        )
  )

(setq browse-url-browser-function 'xwidget-webkit-browse-url)
(map! :n "SPC o m" 'mu4e
      :n "SPC o i" 'erc)

(map! :n "SPC n r r" 'org-roam
      :n "SPC n r i" 'org-roam-insert
      :n "SPC n r f" 'org-roam-find-file
      :n "SPC n r u" 'org-roam-update)

(map! :n "SPC !" 'shell-command)

(defun cc-switch-browser-buffer ()
  "Switch to browser buffer"
  (interactive)
  (let ((this-command 'ivy-switch-buffer))
    (ivy-read "Switch to buffer: " 'internal-complete-buffer
              :matcher #'ivy--switch-buffer-matcher
              :preselect (buffer-name (other-buffer (current-buffer)))
              :action #'ivy--switch-buffer-action
              :keymap ivy-switch-buffer-map
              :caller 'ivy-switch-buffer
              :update-fn 'ivy-call)))

(use-package! md4rd
  :config
  (add-hook 'md4rd-mode-hook 'md4rd-indent-all-the-lines)
  (setq md4rd--oauth-access-token
        "236644830636-lQbAMvmd2Pf9xOXZaC_cuJ0vFwA")
  (setq md4rd--oauth-refresh-token
        "236644830636-ggej2y00GdK7vIvjoiYdzN9khj0")
  (run-with-timer 0 3540 'md4rd-refresh-login)
  (setq md4rd-subs-active '(all 40klore Amd Australia compsci Documentaries gaming
                                emacs GrimDank holochain homestead ImaginaryWarhammer
                                lisp listentothis me_irl movies news nosurf nottheonion
                                PoliticalHumor politics programming Redox rust science
                                space technology unixporn worldnews futurology)))

(use-package! evil-tutor)

(use-package! org-roam
  :after org
  :hook
  (after-init . org-roam-mode)
  :custom
  (org-roam-directory "~/org/"))

(solaire-global-mode 0)

(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))

(defun mu4e-message-maildir-matches (msg rx)
  (when rx
    (if (listp rx)
        ;; if rx is a list, try each one for a match
        (or (mu4e-message-maildir-matches msg (car rx))
            (mu4e-message-maildir-matches msg (cdr rx)))
      ;; not a list, check rx
      (string-match rx (mu4e-message-field msg :maildir)))))


(after! mu4e
  (setq mu4e-contexts
        `( ,(make-mu4e-context
	           :name "Private"
	           :enter-func (lambda () (mu4e-message "Entering Private context"))
             :leave-func (lambda () (mu4e-message "Leaving Private context"))
	           ;; we match based on the contact-fields of the message
	           :match-func (lambda (msg)
			                     (when msg
			                       (mu4e-message-maildir-matches msg "^/gmail")))
	           :vars '( ( user-mail-address	    . "c.a.cunnignham6@gmail.com"  )
		                  ( user-full-name	    . "Charles Cunningham" )
		                  ( mu4e-compose-signature . "- Charles")))
           ,(make-mu4e-context
	           :name "Work"
	           :enter-func (lambda () (mu4e-message "Switch to the Work context"))
	           ;; no leave-func
	           ;; we match based on the maildir of the message
	           ;; this matches maildir /Arkham and its sub-directories
	           :match-func (lambda (msg)
			                     (when msg
			                       (mu4e-message-maildir-matches msg "^/work")))
	           :vars '( ( user-mail-address	     . "charles@jolocom.io" )
		                  ( user-full-name	     . "Charles Cunningham" )
		                  ( mu4e-compose-signature  . "- Charles Cunningham"))))))
