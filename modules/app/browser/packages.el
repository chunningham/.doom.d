;; -*- no-byte-compile: t; -*-
;;; app/browser/packages.el

(when (package! xwwp-full
  :recipe (:host github
           :repo "BlueFlo0d/xwwp"
           :branch "master"
           :files (:defaults "*.js" "*.css")))
(package! ctable)
)
