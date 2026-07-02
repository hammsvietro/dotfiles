;;; lisp/ai.el -*- lexical-binding: t; -*-
;;; AI assistants (Copilot, Claude Code) and the eat terminal helpers they use.

;; Node-based tooling (Copilot, Claude Code) needs the system CA bundle for TLS.
(setenv "NODE_EXTRA_CA_CERTS" "/etc/ssl/certs/ca-certificates.crt")

(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

(use-package! claude-code-ide
  :bind ("C-c C-'" . claude-code-ide-menu)
  :init
  ;; Use the pure-elisp `eat` terminal instead of the default `vterm`.
  ;; Renders the Claude Code TUI more cleanly (no vterm flicker/glitches).
  (setq claude-code-ide-terminal-backend 'eat)
  :config
  (claude-code-ide-emacs-tools-setup)
  ;; Pick the Claude account by project location: sessions rooted under ~/work
  ;; use the work account, everything else uses the personal (default) account.
  ;; CLAUDE_CONFIG_DIR isolates auth/settings/history, mirroring the zsh `claude`
  ;; wrapper in home-manager so the CLI and Emacs behave identically.
  (defun my/claude-work-dir-p (dir)
    "Return non-nil if DIR is within ~/work (recursively)."
    (string-prefix-p (file-name-as-directory (expand-file-name "~/work"))
                     (file-name-as-directory (expand-file-name (or dir default-directory)))))
  (advice-add 'claude-code-ide--create-terminal-session :around
              (lambda (orig-fn buffer-name working-dir &rest args)
                (let ((process-environment
                       (if (my/claude-work-dir-p working-dir)
                           (cons (concat "CLAUDE_CONFIG_DIR="
                                         (expand-file-name "~/.config/claude-work"))
                                 process-environment)
                         process-environment)))
                  (apply orig-fn buffer-name working-dir args))))
  ;; Alt+Enter (M-RET) inserts a newline in the Claude prompt.
  ;; Upstream only binds S-<return>; add M-<return> in the Claude terminal
  ;; buffer by extending the package's own key-setup function.
  (advice-add 'claude-code-ide--setup-terminal-keybindings :after
              (lambda ()
                (local-set-key (kbd "M-<return>") #'claude-code-ide-insert-newline)))
  ;; Doom shows transients below the selected window, which crops the wide
  ;; Claude menu when it opens beside the Claude side window. Give this prefix
  ;; its own full-width bottom side window so no columns get truncated.
  (with-eval-after-load 'claude-code-ide-transient
    (oset (get 'claude-code-ide-menu 'transient--prefix) display-action
          '(display-buffer-in-side-window
            (side . bottom)
            (slot . 0)
            (dedicated . t)
            (inhibit-same-window . t)))))

;; eat runs the Claude Code terminal; these forward keys the TUI needs.
(defun my/eat-send-escape ()
  "Send ESC to the eat terminal."
  (interactive)
  (eat-self-input 1 ?\e))

(defun my/eat-send-backtab ()
  "Send Shift+Tab (backtab) to the eat terminal."
  (interactive)
  (eat-self-input 1 ?\e)
  (eat-self-input 1 ?\[)
  (eat-self-input 1 ?Z))

(map! :map eat-semi-char-mode-map
      :desc "Send ESC to eat terminal"
      :nvi "C-c q" #'my/eat-send-escape)

(with-eval-after-load 'evil
  (evil-define-key '(insert normal emacs) eat-semi-char-mode-map
    (kbd "<backtab>") #'my/eat-send-backtab))
