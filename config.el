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

;; (use-package! which-key-posframe
;;   :config
;;   (which-key-posframe-mode)
;;   (setq which-key-posframe-parameters '((min-width . 180) (min-height . 30) (parent-frame . nil)))
;;   )

(use-package! ytdl)

(defun cc/make-real ()
  (interactive)
  (doom-mark-buffer-as-real-h))

;; (load-file "~/.doom.d/hydras.el")
;; (setq hydra-hint-display-type 'posframe)
;; (after! ivy
;;   (setq ivy-posframe-parameters '((min-width . 90) (min-height . 17) (parent-frame . nil)))
;;   )

;; taken from sarg
;; fix posframes

(after! objed
  ;; create leader key
  (define-key objed-map (kbd "SPC") 'hydra-hail/body)
  (define-key objed-map (kbd "M-x") 'counsel-M-x)

  ;; set S-SPC to toggle objed mode
  (define-key objed-map (kbd "S-SPC") 'objed-quit)
  (define-key global-map (kbd "S-SPC") 'objed-activate)
  (setq-default cursor-type 'bar)
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

;; (map! :n "SPC o m" 'mu4e
;;       :n "SPC o i" 'erc
;;       :n "SPC o s c" 'slack-channel-select
;;       :n "SPC o s d" 'slack-im-select
;;       :n "SPC o s u" 'slack-all-unreads)

(map! :n "U" 'undo-tree-redo)

(add-hook! pdf-view-mode :append :buffer #'pdf-view-midnight-minor-mode)

;; (after! md4rd
;;   ;; (add-hook 'md4rd-mode-hook 'md4rd-indent-all-the-lines)
;;   (setq md4rd--oauth-access-token
;;         "236644830636-lQbAMvmd2Pf9xOXZaC_cuJ0vFwA")
;;   (setq md4rd--oauth-refresh-token
;;         "236644830636-ggej2y00GdK7vIvjoiYdzN9khj0")
;;   (setq md4rd-subs-active '(all 40klore Amd Australia compsci Documentaries gaming
;;                                 emacs GrimDank holochain homestead ImaginaryWarhammer
;;                                 lisp listentothis me_irl movies news nosurf nottheonion
;;                                 PoliticalHumor politics programming Redox rust science
;;                                 space technology unixporn worldnews futurology))
;;   (run-with-timer 0 3540 'md4rd-refresh-login))

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
;; (use-package! sauron
;;   :config
;;   (setq sauron-separate-frame nil
;;         sauron-modules '(sauron-dbus sauron-org)
;;         sauron-max-line-length 120)
;;   (set-popup-rule! (regexp-quote sr-buffer-name)
;;     :size 0.25 :side 'bottom
;;     :select t :quit t :ttl nil)

;;   (when (featurep! :editor evil)
;;     (add-to-list 'evil-normal-state-modes 'sauron-mode)
;;     (map! :map sauron-mode-map
;;           :n "RET" 'sauron-activate-event
;;           :n "c" 'sauron-clear))

;;   (sauron-start-hidden))

(use-package! mini-frame
  :config
  (add-hook 'after-init-hook 'mini-frame-mode)
  (setq mini-frame-standalone t)
  (setq mini-frame-completions-show-parameters '((height . 0.25) (width . 1.0) (left . 0.5) (top . 0.25)))
  )

(use-package! combobulate
  :hook ((rustic-mode . combobulate-mode)
         (js-mode . combobulate-mode)
         (typescript-mode . combobulate-mode)))
