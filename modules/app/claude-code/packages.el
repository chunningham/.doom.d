;; -*- no-byte-compile: t; -*-
;;; app/claude-code/packages.el

;; Main package
(package! claude-code-ide
  :recipe (:host github
           :repo "manzaltu/claude-code-ide.el")
  :pin "853440e3d8cebfef49ba9da5e2991422b8c778f4")

(when (and (not (modulep! :term vterm)) (modulep! +vterm))
  (package! vterm :pin "056ad74653704bc353d8ec8ab52ac75267b7d373"))
