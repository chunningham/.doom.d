;;; app/browser/config.el -*- lexical-binding: t; -*-

(use-package! xwwp-full
  :config
  (use-package! ctable)
  (add-hook! xwidget-webkit-mode (doom-mark-buffer-as-real-h))
  (add-hook! xwidget-webkit-mode (hide-mode-line-mode))
  (map! :mode xwidget-webkit-mode
        :n "o" 'xwwp
        :n "O" 'xwwp-browse-url-other-window
        :n "a" 'xwwp-ace-toggle
        :n "p" 'xwwp-history-show
        :n "s-c" 'xwidget-webkit-copy-selection-as-kill
        :n "s-y" 'xwidget-webkit-copy-selection-as-kill
        )
  (setq browse-url-browser-function 'xwidget-webkit-browse-url)
  (map! :leader
        "o b" 'xwwp
        )
  )
