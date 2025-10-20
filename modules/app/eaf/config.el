;;; app/eaf/config.el -*- lexical-binding: t; -*-

(use-package! eaf
  :config
  (when (modulep! +file-manager)
    (use-package! eaf-file-manager))

  (when (modulep! +music-player)
    (use-package! eaf-music-player))

  (when (modulep! +image-viewer)
    (use-package! eaf-image-viewer))

  (when (modulep! +camera)
    (use-package! eaf-camera))

  (when (modulep! +airshare)
    (use-package! eaf-airshare))

  (when (modulep! +terminal)
    (use-package! eaf-terminal))

  (when (modulep! +markdown-previewer)
    (use-package! eaf-markdown-previewer))

  (when (modulep! +video-player)
    (use-package! eaf-video-player))

  (when (modulep! +js-video-player)
    (use-package! eaf-js-video-player))

  (when (modulep! +file-sender)
    (use-package! eaf-file-sender))

  (when (modulep! +pdf-viewer)
    (use-package! eaf-pdf-viewer))

  (when (modulep! +mindmap)
    (use-package! eaf-mindmap))

  (when (modulep! +jupyter)
    (use-package! eaf-jupyter))

  (when (modulep! +org-previewer)
    (use-package! eaf-org-previewer))

  (when (modulep! +system-monitor)
    (use-package! eaf-system-monitor))

  (when (modulep! +rss-reader)
    (use-package! eaf-rss-reader))

  (when (modulep! +file-browser)
    (use-package! eaf-file-browser))

  (when (modulep! +browser)
    (use-package! eaf-browser
      :config
      (defalias 'browse-web #'eaf-open-browser)
      (map! :desc "browse" :n "SPC o B" 'eaf-open-browser-with-history)
      (setq browse-url-browser-function 'eaf-open-browser)
      (setq eaf-browser-default-search-engine "duckduckgo")
      (setq eaf-browse-blank-page-url "https://duckduckgo.com")
      (setq eaf-browser-dark-mode "force")
      (setq eaf-browser-enable-adblocker t)
      (setq eaf-browser-continue-where-left-off t)))

  (when (modulep! +org)
    (use-package! eaf-org))

  (when (modulep! +mail)
    (use-package! eaf-mail))

  (when (modulep! +git)
    (use-package! eaf-git))

  (when (modulep! +evil)
    (use-package! eaf-evil
      :config
      (when (modulep! :editor evil)
        (evil-set-initial-state 'eaf-mode 'emacs)
        (define-key key-translation-map (kbd "SPC")
                    (lambda (prompt)
                      (if (derived-mode-p 'eaf-mode)
                          (pcase eaf--buffer-app-name
                            ("browser" (if  eaf-buffer-input-focus
                                           (kbd "SPC")
                                         (kbd eaf-evil-leader-key)))
                            ("pdf-viewer" (kbd eaf-evil-leader-key))
                            ("image-viewer" (kbd eaf-evil-leader-key))
                            (_  (kbd "SPC")))
                        (kbd "SPC")))))))

  (when (modulep! +markmap)
    (use-package! eaf-markmap))

  (when (modulep! +demo)
    (use-package! eaf-demo))

  (when (modulep! +vue-demo)
    (use-package! eaf-vue-demo))

  (when (modulep! +vue-tailwindcss)
    (use-package! eaf-vue-tailwindcss))

  (when (modulep! +all-the-icons)
    (use-package! eaf-all-the-icons)))
