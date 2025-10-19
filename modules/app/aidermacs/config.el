;;; app/aidermacs/config.el -*- lexical-binding: t; -*-

(use-package! aidermacs
  :bind (("C-c a" . aidermacs-transient-menu))
  :config
  :custom
  (aidermacs-use-architect-mode t)
  (aidermacs-backend 'vterm)
  (aidermacs-architect-model "o1-mini"))
