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

(use-package! agent-shell
  :defer t
  :config
  (setq agent-shell-anthropic-authentication
        (agent-shell-anthropic-make-authentication :login t)))

(defun my/claude-work-dir-p (dir)
  "Return non-nil if DIR is within ~/work (recursively)."
  (string-prefix-p (file-name-as-directory (expand-file-name "~/work"))
                   (file-name-as-directory (expand-file-name (or dir default-directory)))))

(defun my/agent-shell-claude ()
  "Start an agent-shell Claude session.
Injects CLAUDE_CONFIG_DIR so sessions under ~/work use the work account."
  (interactive)
  (require 'agent-shell)
  ;; `agent-shell-anthropic-claude-environment' is read when the ACP subprocess
  ;; is spawned, so set it (globally) right before launching.
  (setq agent-shell-anthropic-claude-environment
        (when (my/claude-work-dir-p default-directory)
          (list (concat "CLAUDE_CONFIG_DIR="
                        (expand-file-name "~/.config/claude-work")))))
  (agent-shell-anthropic-start-claude-code))

(map! "C-c C-'" #'my/agent-shell-claude)

(defun my/agent-shell-work-badge-a (model)
  "Tag MODEL's project name with WORK for sessions rooted under ~/work."
  (when-let* (((my/claude-work-dir-p default-directory))
              (name (map-elt model :project-name)))
    (setf (map-elt model :project-name) (concat name " [WORK]")))
  model)

(with-eval-after-load 'agent-shell
  (advice-add 'agent-shell--make-header-model :filter-return #'my/agent-shell-work-badge-a))

(with-eval-after-load 'agent-shell
(setq agent-shell-anthropic-claude-environment
      (agent-shell-make-environment-variables
       :inherit-env t
       "ANTHROPIC_MODEL" "opusplan")))
