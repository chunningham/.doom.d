;; -*- no-byte-compile: t; -*-
;;; app/eaf/packages.el

(package! eaf
  :recipe (:host github
           :repo "emacs-eaf/emacs-application-framework"
           :files ("*.el" "*.py" "core" "app" "*.json")
           :includes (eaf-file-manager ; Straight won't try to search for these packages when we make further use-package invocations for them
                      eaf-music-player
                      eaf-image-viewer
                      eaf-camera
                      eaf-airshare
                      eaf-terminal
                      eaf-markdown-previewer
                      eaf-video-player
                      eaf-js-video-player
                      eaf-file-sender
                      eaf-pdf-viewer
                      eaf-mindmap
                      eaf-netease-cloud-music
                      eaf-jupyter
                      eaf-org-previewer
                      eaf-system-monitor
                      eaf-rss-reader
                      eaf-file-browser
                      eaf-browser
                      eaf-org
                      eaf-mail
                      eaf-git
                      eaf-evil
                      eaf-markmap
                      eaf-all-the-icons)
           :pre-build (("python" "install-eaf.py" "--install-all-apps"))))
