;; -*- no-byte-compile: t; -*-
;;; app/claude-code/packages.el

;; Main package
(package! claude-code-ide
  :recipe (:host github
           :repo "manzaltu/claude-code-ide.el")
  :pin "32d853e20b9d245a6ee89c4a153a4e568250c62c")

(when (and (not (modulep! :term vterm)) (modulep! +vterm))
  (package! vterm :pin "056ad74653704bc353d8ec8ab52ac75267b7d373"))
