;;; lisp/ai.el -*- lexical-binding: t; -*-

;; Node tooling (Copilot, Claude Code) needs the system CA bundle for TLS.
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
  ;; `eat` renders the Claude TUI more cleanly than the default `vterm`.
  (setq claude-code-ide-terminal-backend 'eat)
  :config
  (claude-code-ide-emacs-tools-setup)
  ;; Use the work Claude account for sessions under ~/work, personal elsewhere.
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
  ;; M-<return> inserts a newline in the Claude prompt (upstream only binds S-<return>).
  (advice-add 'claude-code-ide--setup-terminal-keybindings :after
              (lambda ()
                (local-set-key (kbd "M-<return>") #'claude-code-ide-insert-newline)))
  ;; Full-width bottom side window for the menu so no columns get truncated.
  (with-eval-after-load 'claude-code-ide-transient
    (oset (get 'claude-code-ide-menu 'transient--prefix) display-action
          '(display-buffer-in-side-window
            (side . bottom)
            (slot . 0)
            (dedicated . t)
            (inhibit-same-window . t)))))

;; Forward keys the Claude TUI needs into the eat terminal.
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
