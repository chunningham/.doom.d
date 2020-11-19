;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;; This emacs was installed via:
;; brew tap daviderestivo/emacs-head
;; brew install emacs-head --HEAD --with-cocoa --with-dbus --with-imagemagick
;; --with-jansson --with-mailutils --with-pdumper

(setq doom-theme 'doom-manegarm)

(setq user-full-name "Charles Cunningham"
      user-mail-address "c.a.cunningham6@gmail.com")

(setq deft-directory org-directory)

(after! calender
  (setq org-gcal-client-id "509352370358-o1j21kpjvjjs15iek9p7ocnv63f24oqc.apps.googleusercontent.com"
        org-gcal-client-secret "Olqey39CAUc_Pc_xy_Og89W0"
        org-gcal-file-alist '(("hildebrand.me_ol6c9vukg2dlh3vm4u58vhjp94@group.calendar.google.com" . "~/org/schedule.org"))))

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

(use-package! which-key-posframe
  :config
  (which-key-posframe-mode)
  (setq which-key-posframe-parameters '((min-width . 180) (min-height . 30) (parent-frame . nil)))
  )

(use-package! ytdl)

(defun cc/make-real ()
  (interactive)
  (doom-mark-buffer-as-real-h))

(use-package! exwm
  ;; :hook doom-mark-buffer-as-real-h
  ;; :hook (exwm-mode . doom-mark-buffer-as-real-h)
  ;; :hook ((hide-mode-line-mode doom-mark-buffer-as-real-h) . exwm-mode-hook)
  :config
  (use-package! exwm-randr
    :hook (exwm-randr-screen-change . (lambda ()
                                        (start-process-shell-command
                                         "xrandr" nil "xrandr --output HDMI1 --mode 1920x1080 --above eDP1")))
    :config
    (setq exwm-randr-workspace-monitor-plist '(0 "eDP1" 1 "DP1"))
    (exwm-randr-enable))

  (use-package! exwm-systemtray
    :config (exwm-systemtray-enable))

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

  (setq lsp-keymap-prefix "s-<return>")

  ;; Global keybindings.
  (unless (get 'exwm-input-global-keys 'saved-value)
    (setq exwm-input-global-keys
          `(
            ;; s-SPC: global leader key
            (,(kbd "s-SPC") . my/press-leader-key)
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
            ;; 's-~': previous project
            (,(kbd "s-~") . +workspace/other)
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

  ;; hooks
  (add-hook! 'exwm-mode-hook #'(doom-mark-buffer-as-real-h hide-mode-line-mode))

  ;; Enable EXWM
  (exwm-enable)
  )

;; (load-file "~/.doom.d/hydras.el")
;; (setq hydra-hint-display-type 'posframe)
;; (after! ivy
;;   (setq ivy-posframe-parameters '((min-width . 90) (min-height . 17) (parent-frame . nil)))
;;   )

;; taken from sarg
;; fix posframes
(defun cc/ivy-posframe-poshandler (info)
  (let ((workarea (elt exwm-workspace--workareas exwm-workspace-current-index))
        (return-value (posframe-poshandler-frame-center info)))

    (cons (+ (aref workarea 0) (car return-value))
          (+ (aref workarea 1) (cdr return-value)))))

(defun cc/ivy-posframe-exwm (str)
  (ivy-posframe--display str #'cc/ivy-posframe-poshandler))

(after! ivy-posframe
  (load! "window")

  (setq ivy-posframe-display-functions-alist '((t . cc/ivy-posframe-exwm))
        ivy-posframe-parameters '((parent-frame nil)))
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
        ;; org-capture-templates
        ;; '(("j" "Journal" entry
        ;;    (file+olp+datetree "journal.org" "Inbox")
        ;;    "* %U %?\n%i" :prepend t)
        ;;   ("i" "Inbox" entry
        ;;    (file "inbox.org")
        ;;    "* TODO %i%?\n%a\n")
        ;;   ("T" "Tickler" entry
        ;;    (file "tickler.org")
        ;;    "* %i%?\n%U")
        ;;   ("c" "Current Task Note" entry
        ;;    (clock)
        ;;    "* %i%?\n%a")
        ;;   ("p" "Project todo" entry
        ;;    (file+function "projects.org" projectile-project-name)
        ;;    "* TODO %?\n %i\n %a"))
        org-refile-targets
        '(("inbox.org" :maxlevel . 2)
          ("projects.org" :maxlevel . 3)
          ("someday.org" :level . 1)
          ("tickler.org" :maxlevel . 2))
        )
  )

(use-package! doct
  :after (org)
  :config
  (setq org-capture-templates
        (doct '(("Journal" :keys "j"
                 :file "journal.org"
                 :template "* %U %?\n%i"
                 :datetree t)
                ("Inbox" :keys "i"
                 :file "inbox.org"
                 :template "* TODO %i%?\n%a\n")
                ("Gym" :keys "g"
                 :file "projects.org"
                 :id "80A8C875-E97F-4119-B79F-314831DBFFD2"
                 :type table-line
                 :template "|%t|%^{today's weight}|%^{squat}|%^{bench}|%^{pendlay row}|%^{deadlift}|%^{overhead press}|%^{turkish get-up}|%^{barbell shrug}|%^{notes}|")
                ("Meditation" :keys "m"
                 :file "projects.org"
                 :id "8533A37F-FF97-432A-AC1E-6AAE4D011840"
                 :type table-line
                 :template "|%t|%^{time}|%i|")
                ))))

(map! :n "SPC o m" 'mu4e
      :n "SPC o i" 'erc
      :n "SPC o s c" 'slack-channel-select
      :n "SPC o s d" 'slack-im-select
      :n "SPC o s u" 'slack-all-unreads)

(map! :n "U" 'undo-tree-redo)

(add-hook! pdf-view-mode :append :buffer #'pdf-view-midnight-minor-mode)

(after! md4rd
  ;; (add-hook 'md4rd-mode-hook 'md4rd-indent-all-the-lines)
  (setq md4rd--oauth-access-token
        "236644830636-lQbAMvmd2Pf9xOXZaC_cuJ0vFwA")
  (setq md4rd--oauth-refresh-token
        "236644830636-ggej2y00GdK7vIvjoiYdzN9khj0")
  (setq md4rd-subs-active '(all 40klore Amd Australia compsci Documentaries gaming
                                emacs GrimDank holochain homestead ImaginaryWarhammer
                                lisp listentothis me_irl movies news nosurf nottheonion
                                PoliticalHumor politics programming Redox rust science
                                space technology unixporn worldnews futurology))
  (run-with-timer 0 3540 'md4rd-refresh-login))

;; (solaire-global-mode 0)

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

(slack-register-team
 :name "jolocom"
 :default t
 :token "xoxs-3647896349-562530281909-1020866050723-e924ddc0ece43dc42171d75c1f8c9c0ce6187d1f020ee15d70447702e50627bf"
 :subscribed-channels '(availability calendar design_n_content dev dev_business dev_identity
                                     dev_integrations devdev dif eevents eljolocomworkshop
                                     external_comm general hid hiringnew lunch osip-interop-poc
                                     p2p papyri positioning_and_messaging privacyassessment
                                     productownerteam socialmedia standup strategy team telekom
                                     tellingstories urgent waldemarstr-37a website whitepaper))

(slack-register-team
 :name "difdn"
 :token "xoxs-165669436000-544672028195-1002487213604-c5a4989d942b796943791e6b893b1bf5fa0baf6fbd6ac86a42edffe9304ebc17"
 :subscribed-channels '(general interop_project peer-did wg-auth wg-claims-credentials
                                wg-didcomm wg-id))

(slack-register-team
 :name "odysseyssiteam"
 :token "xoxs-935348418500-937668157335-985592732129-2f2376cbfa3ebe40e14c5f2790af4099553ed70c168b0609ae2b97b1b690930e"
 :subscribed-channels '(allgemein ssi-interop-odyssey))

(use-package! sauron
  :config
  (setq sauron-separate-frame nil
        sauron-modules '(sauron-dbus sauron-org)
        sauron-max-line-length 120)
  (set-popup-rule! (regexp-quote sr-buffer-name)
    :size 0.25 :side 'bottom
    :select t :quit t :ttl nil)

  (after! slack
    (load! "sauron-slack")
    (add-to-list 'sauron-modules 'sauron-slack)
    (sauron-slack-start))

  (when (featurep! :editor evil)
    (add-to-list 'evil-normal-state-modes 'sauron-mode)
    (map! :map sauron-mode-map
          :n "RET" 'sauron-activate-event
          :n "c" 'sauron-clear))

  (sauron-start-hidden))
