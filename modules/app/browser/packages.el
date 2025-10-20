;; -*- no-byte-compile: t; -*-
;;; app/browser/packages.el

(when (package! xwwp-full
        :recipe (:host github
                 :repo "modeverv/xwwp"
                 :files (:defaults "*.js" "*.css"))
        :pin "6021e7ebc028c1b132f4dc88aea12105ef596b82")
  (package! ctable))
