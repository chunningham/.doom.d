;;; desktop/eaf/config.el -*- lexical-binding: t; -*-

(use-package! eaf
  :load-path "/usr/share/emacs/site-lisp/eaf"
  :config
  (evil-set-initial-state 'eaf-mode 'emacs)
  (setq browse-url-browser-function 'eaf-open-browser)
  (map! :desc "browse" :n "SPC o B" 'eaf-open-browser-with-history))
