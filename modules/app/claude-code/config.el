;;; app/claude-code/config.el -*- lexical-binding: t; -*-

(use-package! claude-code-ide
  :defer t
  :init
  ;; Set up keybindings under the AI prefix
  (map! :leader
        (:prefix ("-" . "AI/Claude")
         :desc "Claude Code menu"           "c" #'claude-code-ide-menu
         :desc "Start Claude Code"          "s" #'claude-code-ide
         :desc "Resume conversation"        "r" #'claude-code-ide-resume
         :desc "Stop Claude Code"           "q" #'claude-code-ide-stop
         :desc "Send region to Claude"      "R" #'claude-code-ide-send-region
         :desc "Send buffer to Claude"      "b" #'claude-code-ide-send-buffer
         :desc "Send project info"          "p" #'claude-code-ide-send-project))
  
  ;; Global keybinding for quick access
  (map! :g "C-c '" #'claude-code-ide-menu)
  
  :config
  ;; Enable MCP tools for bidirectional communication
  (claude-code-ide-emacs-tools-setup)
  
  ;; Customize window placement (right side by default in Doom)
  (setq claude-code-ide-side-window-position 'right)
  
  ;; Set buffer naming convention
  (setq claude-code-ide-buffer-name-function
        (lambda (project-root)
          (format "*Claude Code: %s*" (projectile-project-name))))
  
  ;; Optional: Add custom CLI flags
  ;; (setq claude-code-ide-extra-flags '("--max-tokens" "4096"))
  
  ;; Optional: Enable debug mode for troubleshooting
  ;; (setq claude-code-ide-debug t)
  
  ;; Integration with Doom's popup system
  (set-popup-rule! "^\\*Claude Code:" 
    :side 'right 
    :size 0.5 
    :select t 
    :quit nil
    :ttl nil))
