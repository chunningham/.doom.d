;; -*- no-byte-compile: t; -*-
;;; app/copilot/packages.el

;; Main package
(package! copilot
  :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el")))
