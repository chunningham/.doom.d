;; -*- no-byte-compile: t; -*-
;;; app/claude-code/packages.el

(when (package! claude-code-ide
        :recipe (:host github :repo "manzaltu/claude-code-ide.el"))
  ;; Dependencies
  (package! vterm))  ;; Required for terminal integration
