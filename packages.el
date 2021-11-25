;; -*- no-byte-compile: t; -*-
;;; ~/.doom.d/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:fetcher github :repo "username/repo"))
;; (package! builtin-package :disable t)

(package! exwm)

(package! desktop-environment)

;; (package! which-key-posframe)

(package! gpastel)

(package! doct)

(package! sauron)

(package! ytdl)

(package! mini-frame)

(unpin! magit forge)

(package! combobulate :recipe (:host github :repo "chunningham/combobulate" :branch "feat/rust"))
(package! tree-sitter-langs)

(package! gitconfig-mode :recipe (:host github :repo "magit/git-modes" :files ("gitconfig-mode.el")))
(package! gitignore-mode :recipe (:host github :repo "magit/git-modes" :files ("gitignore-mode.el")))


;; (package! lastfm)

;; (package! vuiet)
