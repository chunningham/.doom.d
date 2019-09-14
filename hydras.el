;;; ~/.doom.d/hydras.el -*- lexical-binding: t; -*-


;; My hydras
(defhydra hydra-hail (:color blue
                             :hint nil)
  "
_g_it  | _f_iles
_o_rg  | _b_uffers
_a_pp  | _p_rojects
_s_esh | _w_indows
_d_esk | _l_ookup
"
  ("f" cc/hydra-files/body)
  ("b" cc/hydra-buffers/body)
  ("p" cc/hydra-projects/body)
  ("d" cc/hydra-workspaces/body)
  ("a" cc/hydra-applications/body)
  ("s" cc/hydra-session/body)
  ("g" cc/hydra-git/body)
  ("o" cc/hydra-org/body)
  ("l" cc/hydra-lookup/body)
  ("i" cc/hydra-ide/body)
  ("w" cc/hydra-window/body)
  ("." nil)
  ("SPC" nil)
  )

(defhydra cc/hydra-files (:color blue
                                 :hint nil)
  "
Files
^-^------|-^-^------
_f_ind   | _m_ove
_s_ave   | _r_ecent
s_u_do   | _e_xplore
_c_onfig | _d_elete
  "
  ("f" find-file)
  ("s" save-buffer)
  ("u" doom/sudo-find-file)
  ("c" doom/open-private-config)
  ("m" doom/move-this-file)
  ("r" recentf-open-files)
  ("e" dired)
  ("d" doom/delete-this-file)
  ("." nil)
  ("SPC" hydra-hail/body)
  )

(defhydra cc/hydra-buffers (:color blue
                            :hint nil)
  "
Buffers
^-^-------|-^-^------
_b_uffers | _s_cratch
_k_ill    | _o_nly
_m_enu    | _l_ast
_[__]_: prev/next
"
  ("b" projectile-switch-to-buffer)
  ("k" kill-this-buffer)
  ("m" ibuffer)
  ("[" projectile-next-project-buffer :color red)
  ("]" projectile-previous-project-buffer :color red)
  ("s" doom/open-project-scratch-buffer)
  ("o" doom/kill-other-buffers)
  ("l" projectile-previous-project-buffer)
  ("." nil)
  ("SPC" hydra-hail/body)
  )

(defhydra cc/hydra-projects (:color blue
                             :hint nil)
  "
%(projectile-project-root)
^-^--------|-^-^-----
_p_rojects | _j_obs
_a_dd      | _r_emove
_s_ave all | _k_ill
_i_ibuffer | _t_ree
"
  ("p" projectile-switch-project)
  ("a" projectile-add-known-project)
  ("s" projectile-save-project-buffers)
  ("j" +default/project-tasks)
  ("r" projectile-remove-known-project)
  ("k" projectile-kill-buffers)
  ("i" projectile-ibuffer)
  ("t" treemacs)
  ("." nil)
  ("SPC" hydra-hail/body)
  )

(defhydra cc/hydra-workspaces (:color blue
                               :hint nil)
  "
Workspaces
^-^----------|-^-^-----
_w_orkspaces | _l_oad
_n_ew        | _d_elete
_s_ave       | _k_ill
_[__]_: prev/next
"
  ("w" +workspace/switch-to)
  ("n" +workspace/new)
  ("s" +workspace/save)
  ("l" +workspace/load)
  ("d" +workspace/delete)
  ("k" projectile-kill-buffers)
  ("[" +workspace/switch-left :color red)
  ("]" +workspace/switch-right :color red)
  ("." nil)
  ("SPC" hydra-hail/body)
  )

(defhydra cc/hydra-applications (:color blue
                                 :hint nil)
  "
Applications
^-^--------|-^-^-----
_t_erminal | _m_ail
_c_alender | _i_rc
_s_lack    | _a_genda
"
  ("t" +vterm/toggle)
  ("c" my-open-calender)
  ("s" nil)
  ("m" =mu4e)
  ("i" irc)
  ("a" org-agenda)
  ("." nil)
  ("SPC" hydra-hail/body)
  )

(defhydra cc/hydra-session (:color blue
                            :hint nil)
  "
Session
^-^-------|-^-^-------------
_q_uit    | _Q_uit hard
_r_estart | _R_estart hard
_l_oad    | _L_oad from file
_s_ave    | _S_ave to file

"
  ("q" save-buffers-kill-terminal)
  ("Q" nil);;evil-quit-all-with-error-code)
  ("r" doom/restart-and-restore)
  ("R" doom/restart)
  ("l" doom/quickload-session)
  ("L" doom/load-session)
  ("s" doom/quicksave-session)
  ("S" doom/save-session)
  ("." nil)
  ("SPC" hydra-hail/body)
  )

(defhydra cc/hydra-org (:color blue
                        :hint nil)
  "
Org
^-^-------|-^-^-----
_a_genda  | _n_otes
_c_apture | _s_earch
"
  ("a" org-agenda)
  ("n" +default/browse-notes)
  ("c" org-capture)
  ("s" +default/org-notes-search)
  ("." nil)
  ("SPC" hydra-hail/body)
  )

(defhydra cc/hydra-lookup (:color blue
                           :hint nil)
  "
Lookup
^-^----|-^-^--
"
  ("SPC" hydra-hail/body)
  )

(defhydra cc/hydra-yasnippet (:color blue :hint nil)
  "
YASnippets
--------------------------------------------
  Modes:    Load/Visit:    Actions:

 _g_lobal  _d_irectory    _i_nsert
 _m_inor   _f_ile         _t_ryout
 _e_xtra   _l_ist         _n_ew
         _a_ll
"
  ("d" yas-load-directory)
  ("e" yas-activate-extra-mode)
  ("i" yas-insert-snippet)
  ("f" yas-visit-snippet-file :color blue)
  ("n" yas-new-snippet)
  ("t" yas-tryout-snippet)
  ("l" yas-describe-tables)
  ("g" yas/global-mode)
  ("m" yas/minor-mode)
  ("a" yas-reload-all)
  ("." nil)
  ("SPC" hydra-hail/body)
  )

 (defhydra cc/hydra-window (:hint nil)
   "
Movement^^        ^Split^         ^Switch^		^Resize^
----------------------------------------------------------------
_h_ ←       	_v_ertical    	_b_uffer		_q_ X←
_j_ ↓        	_x_ horizontal	_f_ind files	_w_ X↓
_k_ ↑        	_z_ undo      	_a_ce 1		_e_ X↑
_l_ →        	_Z_ reset      	_s_wap		_r_ X→
_F_ollow		_D_lt Other   	_S_ave		max_i_mize
_._ cancel	_o_nly this   	_d_elete
"
   ("h" windmove-left )
   ("j" windmove-down )
   ("k" windmove-up )
   ("l" windmove-right )
   ("q" hydra-move-splitter-left)
   ("w" hydra-move-splitter-down)
   ("e" hydra-move-splitter-up)
   ("r" hydra-move-splitter-right)
   ("b" helm-mini)
   ("f" helm-find-files)
   ("F" follow-mode)
   ("a" (lambda ()
          (interactive)
          (ace-window 1)
          (add-hook 'ace-window-end-once-hook
                    'hydra-window/body))
       )
    ("v" (lambda ()
          (interactive)
          (split-window-right)
          (windmove-right))
       )
   ("x" (lambda ()
          (interactive)
          (split-window-below)
          (windmove-down))
       )
   ("s" (lambda ()
          (interactive)
          (ace-window 4)
          (add-hook 'ace-window-end-once-hook
                    'hydra-window/body)))
   ("S" save-buffer)
   ("d" delete-window)
   ("D" (lambda ()
          (interactive)
          (ace-window 16)
          (add-hook 'ace-window-end-once-hook
                    'hydra-window/body))
       )
   ("o" delete-other-windows)
   ("i" ace-maximize-window)
   ("z" (progn
          (winner-undo)
          (setq this-command 'winner-undo))
   )
   ("Z" winner-redo)
   ("SPC" hydra-hail/body :color blue)
   ("." nil)
   )

(defhydra cc/hydra-git-gutter (:body-pre (git-gutter-mode 1)
                            :hint nil)
  "
Git gutter:
  _[__]_: prev/next  _s_tage      _q_uit
  _{__}_: first/last _r_evert     _Q_uit and deactivate git-gutter
  ^ ^^ ^             _p_opup      start _R_evision
"
  ("]" git-gutter:next-hunk)
  ("[" git-gutter:previous-hunk)
  ("{" (progn (goto-char (point-min))
              (git-gutter:next-hunk 1)))
  ("}" (progn (goto-char (point-min))
              (git-gutter:previous-hunk 1)))
  ("s" git-gutter:stage-hunk)
  ("r" git-gutter:revert-hunk)
  ("p" git-gutter:popup-hunk)
  ("R" git-gutter:set-start-revision)
  ("q" nil :color blue)
  ("Q" (progn (git-gutter-mode -1)
              ;; git-gutter-fringe doesn't seem to
              ;; clear the markup right away
              (sit-for 0.1)
              (git-gutter:clear))
       :color blue)
  ("." nil :color blue)
  )

(defhydra cc/hydra-git (:color blue
                               :hint nil)
  "
Git
^-^--------^-^----------
_g_it    | _s_tage
_h_unks  | _d_iff
_c_ommit | _t_imemachine
"
  ("g" magit-status)
  ("h" cc/hydra-git-gutter/body)
  ("c" magit-commit)
  ("s" magit-stage-file)
  ("d" magit-diff)
  ("t" git-timemachine)
  ("." nil)
  ("SPC" hydra-hail/body)
  )

(defhydra cc/hydra-ide (:exit t :hint nil)
  "
 Buffer^^               Server^^                   Symbol
-------------------------------------------------------------------------------------
 [_f_] format           [_M-r_] restart            [_d_] declaration  [_i_] implementation  [_o_] documentation
 [_m_] imenu            [_S_]   shutdown           [_D_] definition   [_t_] type            [_r_] rename
 [_x_] execute action   [_M-s_] describe session   [_R_] references   [_s_] signature"
  ("d" lsp-find-declaration)
  ("D" lsp-ui-peek-find-definitions)
  ("R" lsp-ui-peek-find-references)
  ("i" lsp-ui-peek-find-implementation)
  ("t" lsp-find-type-definition)
  ("s" lsp-signature-help)
  ("o" lsp-describe-thing-at-point)
  ("r" lsp-rename)

  ("f" lsp-format-buffer)
  ("m" lsp-ui-imenu)
  ("x" lsp-execute-code-action)

  ("M-s" lsp-describe-session)
  ("M-r" lsp-restart-workspace)
  ("S" lsp-shutdown-workspace)
  ("." nil)
  ("SPC" hydra-hail/body)
  )
