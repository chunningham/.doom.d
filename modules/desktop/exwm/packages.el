;; -*- no-byte-compile: t; -*-
;;; desktop/exwm/packages.el

;; window manager
(package! xelb :recipe (:host github :repo "ch11ng/xelb"))
(package! exwm :recipe (:host github :repo "ch11ng/exwm"))

;; clipboard manager
(package! gpastel)

;; audio control
(package! pulseaudio-control)

;; backlight control
(package! backlight)

;; dmenu control
(package! dmenu)

;; frame control
(package! frame-purpose)
(package! frame-workflow (:recipe (:host github :repo "akirak/frame-workflow")))

;; mouse finder
;; (package! exwm-mff :recipe (:host github :repo "ieure/exwm-mff"))
