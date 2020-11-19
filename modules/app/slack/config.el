;;; app/slack/config.el -*- lexical-binding: t; -*-

(use-package! slack
  :init
  (setq slack-buffer-emojify t          ; if you want emojis
        slack-prefer-current-team t)
  (set-popup-rule! "^\\*Slack" :ignore t)
  :config
  (map! :map slack-info-mode-map
        :localleader
        :desc "update" "u" 'slack-room-update-messages)
  (map! :map slack-mode-map
        :localleader
        :desc "kill" "c" 'slack-buffer-kill
        (:prefix-map ("r" . "reactions")
          :desc "add" "a" 'slack-message-add-reaction
          :desc "remove" "r" 'slack-message-remove-reaction
          :desc "list who" "l" 'slack-message-show-reaction-users)
        (:prefix-map ("p" . "pinned")
          :desc "list" "l" 'slack-room-pins-list
          :desc "add" "a" 'slack-message-pins-add
          :desc "remove" "r" 'slack-message-pins-remove)
        (:prefix-map ("m" . "messages")
          :desc "write" "m" 'slack-message-write-another-buffer
          :desc "edit" "e" 'slack-message-edit
          :desc "delete" "d" 'slack-mseeage-delete)
        :desc "update" "u" 'slack-room-update-messages
        :desc "mention user" "2" 'slack-message-embed-mention
        :desc "mention channel" "3" 'slack-message-embed-channel)
  (map! :map slack-edit-message-mode-map
        :localleader
        :desc "cancel" "c" 'slack-message-cancel-edit
        :desc "send" "s" 'slack-message-send-from-buffer
        :desc "mention user" "2" 'slack-message-embed-mention
        :desc "mention channel" "3" 'slack-message-embed-channel)

  (slack-start))
