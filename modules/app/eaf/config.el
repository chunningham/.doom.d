;;; app/eaf/config.el -*- lexical-binding: t; -*-

(use-package! eaf
  :init (evil-set-initial-state 'eaf-mode 'emacs)
  :custom
  (eaf-browser-continue-where-left-off t)
  (eaf-browser-enable-adblocker t)
  (browse-url-browser-function 'eaf-open-browser) ;; Make EAF Browser my default browser
  :config
  (evil-set-initial-state 'eaf-mode 'emacs)
  (setq browse-url-browser-function 'eaf-open-browser)
  (map! :desc "browse" :n "SPC o B" 'eaf-open-browser-with-history))
