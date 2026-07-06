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

(defun my/claude-send-escape ()
  ;; Plain ESC is routed to evil; this sends a real bare escape to Claude.
  (interactive)
  (ghostel--on-user-input)
  (ghostel--send-encoded "escape" ""))

;; Register at load time so the hook fires regardless of evil-ghostel load order.
(add-hook 'ghostel-mode-hook #'evil-ghostel-mode)

(after! evil-ghostel
  (setq evil-ghostel-escape 'evil)
  (evil-define-key* '(normal insert) evil-ghostel-mode-map
    (kbd "S-<tab>")    #'ghostel--send-event
    (kbd "<backtab>")  #'ghostel--send-event
    (kbd "S-<return>") #'ghostel--send-event
    (kbd "S-<escape>") #'my/claude-send-escape))

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
  (setq claude-code-ide-terminal-backend 'ghostel)
  :config
  (setq claude-code-ide-cli-extra-flags "--model opusplan")
  (advice-add 'claude-code-ide--setup-terminal-keybindings :around
              #'my/claude-code-ide--skip-ghostel-keys)
  (advice-add 'claude-code-ide :around #'my/claude-code-ide--inject-work-env))

(map! "C-c C-'" #'claude-code-ide-menu)
