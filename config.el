;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(setq doom-theme 'doom-molokai)

(after! calender
  (setq org-gcal-client-id "509352370358-o1j21kpjvjjs15iek9p7ocnv63f24oqc.apps.googleusercontent.com"
      org-gcal-client-secret "Olqey39CAUc_Pc_xy_Og89W0"
      org-gcal-file-alist '(("c.a.cunningham6@gmail.com" . "~/org/schedule.org")
                            ("hildebrand.me_ol6c9vukg2dlh3vm4u58vhjp94@group.calendar.google.com" . "~/org/schedule.org"))))

(defun my-open-calendar ()
  (interactive)
  (cfw:open-calendar-buffer
   :contents-sources
   (list
    (cfw:org-create-source "Green")  ; orgmode source
    ;;(cfw:howm-create-source "Blue")  ; howm source
    ;;(cfw:cal-create-source "Orange") ; diary source
    ;;(cfw:ical-create-source "Moon" "~/moon.ics" "Gray")  ; ICS source1
    ;;(cfw:ical-create-source "gcal" "https://..../basic.ics" "IndianRed") ; google calendar ICS
   )))

(after! hydra
  ;; load my hydras
  (load-file "~/.doom.d/hydras.el")

  ;; set hydras to be posframes
  (setq hydra-hint-display-type 'posframe)
  )

(after! objed
  ;; create leader key
  (define-key objed-map (kbd "SPC") 'hydra-hail/body)
  (define-key objed-map (kbd "M-x") 'counsel-M-x)
  )
