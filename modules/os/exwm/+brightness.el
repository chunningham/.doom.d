;;; desktop/exwm/+brightness.el -*- lexical-binding: t; -*-

(defvar cc-redshift-timer 'nil
  "Stores redshift-adjust timer")

(defun cc/redshift-adjust ()
  (interactive)
  (start-process-shell-command "redshift" nil "redshift" "-m randr -Po"))

(defun cc/redshift-start ()
  (interactive)
  (unless cc-redshift-timer
    (setq cc-redshift-timer (run-at-time nil 60 #'cc/redshift-adjust))))

(defun cc/redshift-cancel ()
  (interactive)
  (when cc-redshift-timer (cancel-timer cc-redshift-timer))
  (start-process-shell-command "redshift" nil "redshift" "-x"))

(use-package! backlight)

(spacemacs/exwm-bind-command
 "<XF86MonBrightnessUp>"   `backlight
 "<XF86MonBrightnessDown>" `backlight)

(cc/redshift-start)
