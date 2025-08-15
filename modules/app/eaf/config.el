;;; app/eaf/config.el -*- lexical-binding: t; -*-

(use-package! eaf
  :custom
  (eaf-browser-continue-where-left-off t)
  (eaf-browser-enable-adblocker t)
  (browse-url-browser-function 'eaf-open-browser) ;; Make EAF Browser my default browser
  :config
  (evil-set-initial-state 'eaf-mode 'emacs)
  (setq browse-url-browser-function 'eaf-open-browser)
  (defalias 'browse-web #'eaf-open-browser)
  (map! :desc "browse" :n "SPC o B" 'eaf-open-browser-with-history)
  (setq eaf-browser-default-search-engine "duckduckgo")
  (setq eaf-browse-blank-page-url "https://duckduckgo.com"))
