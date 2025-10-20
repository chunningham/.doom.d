;; -*- no-byte-compile: t; -*-
;;; app/agent-shell/packages.el

;; Main package
(when (package! agent-shell :recipe (:host github :repo "xenodium/agent-shell"))
  (package! shell-maker)
  (package! acp :recipe (:host github :repo "xenodium/acp.el")))

(when (modulep! +sidebar)
  (package! agent-shell-sidebar :recipe (:host github :repo "cmacrae/agent-shell-sidebar")))
