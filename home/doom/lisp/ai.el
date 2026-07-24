;;; lisp/ai.el -*- lexical-binding: t; -*-

(setenv "NODE_EXTRA_CA_CERTS" "/etc/ssl/certs/ca-certificates.crt")

(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

(use-package! ghostel
  :defer t
  :config
  (setq ghostel-readonly-fast-exit t
        ;; evil navigation in normal state moves point off the input — keep
        ;; semi-char mode instead of auto-switching to copy (read-only) mode.
        ghostel-point-leave-input-mode nil
        ghostel-mark-activation-input-mode nil))

;; Register at load time so the hook fires regardless of evil-ghostel load order.
(add-hook 'ghostel-mode-hook #'evil-ghostel-mode)

;; ghostel is a terminal buffer; line numbers flicker as output streams.
(add-hook 'ghostel-mode-hook (lambda () (display-line-numbers-mode -1)))

(after! evil-ghostel
  (setq evil-ghostel-escape 'auto)
  (evil-define-key* '(normal insert) evil-ghostel-mode-map
    (kbd "S-<tab>")    #'ghostel--send-event
    (kbd "<backtab>")  #'ghostel--send-event
    (kbd "S-<return>") #'ghostel--send-event
    (kbd "S-<escape>") #'evil-force-normal-state
    (kbd "M-<escape>") #'evil-force-normal-state))

(defun my/claude-code-ide--skip-ghostel-keys (orig-fn &rest args)
  ;; claude-code-ide rebinds S-<return> to a backslash-return hack that breaks
  ;; ghostel's Kitty-protocol encoder; skip it for the ghostel backend.
  (unless (eq claude-code-ide-terminal-backend 'ghostel)
    (apply orig-fn args)))

(defun my/claude-work-dir-p (dir)
  "Return non-nil if DIR is within ~/work (recursively)."
  (string-prefix-p (file-name-as-directory (expand-file-name "~/work"))
                   (file-name-as-directory (expand-file-name (or dir default-directory)))))

(defun my/claude-code-ide--inject-work-env (orig-fn &rest args)
  (let ((process-environment
         (if (my/claude-work-dir-p default-directory)
             (cons (concat "CLAUDE_CONFIG_DIR=" (expand-file-name "~/.config/claude-work"))
                   process-environment)
           process-environment)))
    (apply orig-fn args)))

(use-package! claude-code-ide
  :defer t
  :init
  ;; Claude's own vim mode owns ESC (claude-code-ide otherwise pins these buffers
  ;; to 'evil, routing ESC to evil normal state); reach evil normal via S-<escape>.
  (setq claude-code-ide-terminal-backend 'ghostel
        claude-code-ide-ghostel-evil-escape 'terminal)
  :config
  (advice-add 'claude-code-ide--setup-terminal-keybindings :around
              #'my/claude-code-ide--skip-ghostel-keys)
  (advice-add 'claude-code-ide :around #'my/claude-code-ide--inject-work-env))

(defvar my/claude-code-ide--fullscreen-config nil
  "Window configuration to restore when leaving Claude fullscreen.")

(defun my/claude-code-ide-toggle-fullscreen ()
  "Toggle the current project's Claude window between side window and full frame."
  (interactive)
  (if my/claude-code-ide--fullscreen-config
      (progn
        (set-window-configuration my/claude-code-ide--fullscreen-config)
        (setq my/claude-code-ide--fullscreen-config nil))
    (let ((buffer (get-buffer (claude-code-ide--get-buffer-name))))
      (unless (buffer-live-p buffer)
        (user-error "No Claude Code session for this project"))
      (setq my/claude-code-ide--fullscreen-config (current-window-configuration))
      ;; A side window can't become the sole window, so drop it before full-framing.
      (when-let ((win (get-buffer-window buffer)))
        (when (window-parameter win 'window-side)
          (delete-window win)))
      (select-window (display-buffer-full-frame buffer nil)))))

(after! claude-code-ide-transient
  (transient-append-suffix 'claude-code-ide-menu 'claude-code-ide-toggle-recent
    '("f" "Toggle fullscreen" my/claude-code-ide-toggle-fullscreen)))

(map! "C-c C-'" #'claude-code-ide-menu)
