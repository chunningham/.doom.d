;; -*- no-byte-compile: t; -*-
;;; app/mosaic/packages.el

(when (package! mosaic
        :recipe (:host gitlab :repo "dto/mosaic-el" ))
  (package! tabbar)
  (package! sr-speedbar)
  (package! jeison))
