;;; app/agent-shell/config.el -*- lexical-binding: t; -*-

(use-package! agent-shell
  :config
  (use-package! shell-maker)
  (use-package! acp)
  (when (modulep! +sidebar)
    (use-package! agent-shell-sidebar)))
