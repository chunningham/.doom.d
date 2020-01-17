;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;; This emacs was installed via:
;; brew tap daviderestivo/emacs-head
;; brew install emacs-head --HEAD --with-cocoa --with-dbus --with-imagemagick
;; --with-jansson --with-mailutils --with-pdumper

(setq doom-theme 'doom-molokai)

(setq user-full-name "Charles Cunningham"
      user-mail-address "c.a.cunningham6@gmail.com")

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

(load-file "~/.doom.d/hydras.el")
(setq hydra-hint-display-type 'posframe)

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
           "TODO(t)"  ; A task that needs doing & is ready to do
           "PROJ(p)"  ; An ongoing project that cannot be completed in one step
           "STRT(s)"  ; A task that is in progress
           "WAIT(w@)"  ; Something is holding up this task; or it is paused
           "|"
           "DONE(d!)"  ; Task successfully completed
           "KILL(k@)") ; Task was cancelled, aborted or is no longer applicable
          (sequence
           "[ ](T)"   ; A task that needs doing
           "[-](S)"   ; Task is in progress
           "[?](W)"   ; Task is being held up or paused
           "|"
           "[X](D)")) ; Task was completed
        org-capture-templates
        '(("j" "Journal" entry
           (file+olp+datetree "journal.org" "Inbox")
           "* %U %?\n%i" :prepend t)
          ("i" "Inbox" entry
           (file "inbox.org")
           "* TODO %i%?\n%a")
          ("T" "Tickler" entry
           (file+headline "tickler.org" "Tickler")
           "* %i%?\n%U")
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

(use-package! md4rd
  :config
  (add-hook 'md4rd-mode-hook 'md4rd-indent-all-the-lines)
  (setq md4rd-subs-active '(emacs lisp+Common_Lisp prolog clojure))
  (setq md4rd--oauth-access-token
        "236644830636-lQbAMvmd2Pf9xOXZaC_cuJ0vFwA")
  (setq md4rd--oauth-refresh-token
        "236644830636-ggej2y00GdK7vIvjoiYdzN9khj0")
  (run-with-timer 0 3540 'md4rd-refresh-login))

(solaire-global-mode 0)

(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))
