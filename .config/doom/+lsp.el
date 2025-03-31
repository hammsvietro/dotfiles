;;; $DOOMDIR/+lsp.el -*- lexical-binding: t; -*-

(use-package! lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp)))
  :config
  (setq lsp-pyright-auto-search-paths t))

(add-hook 'lsp-mode-hook
	  (lambda ()
	    (if (file-exists-p (concat (lsp--workspace-root (cl-first (lsp-workspaces))) "/pyrightconfig.json"))
		(progn
		  (setq lsp-enable-file-watchers t)
		  (setq lsp-file-watch-ignored-directories (eval (car (get 'lsp-file-watch-ignored-directories 'standard-value))))
		  (require 'json)
		  (let* ((json-object-type 'hash-table)
			 (json-array-type 'list)
			 (json-key-type 'string)
			 (json (json-read-file (concat (lsp--workspace-root (cl-first (lsp-workspaces))) "/pyrightconfig.json")))
			 (exclude (gethash "exclude" json)))
		    (dolist (exclud exclude)
		      (push exclud lsp-file-watch-ignored))))
	      (setq lsp-enable-file-watchers 'nil)
	      (setq lsp-file-watch-ignored-directories (eval (car (get 'lsp-file-watch-ignored-directories 'standard-value)))))
	    ))

(map! :leader
      :desc "Peek the docs"
      "c g" #'lsp-ui-doc-glance)

(map! :leader
      :desc "Open docs in minibuffer"
      "c G" #'lsp-describe-thing-at-point)

(map! :leader
      :desc "Explain error at point"
      "e" #'flycheck-explain-error-at-point)

(setq lsp-rust-features "all")
(setq lsp-rust-all-features 't)

;; Disable ESLint in LSP and Flycheck
(after! lsp-mode
  (setq lsp-disabled-clients '(pylsp eslint)))  ;; ESLint disabled properly

(after! flycheck
  (setq-default flycheck-disabled-checkers '(javascript-eslint typescript-tslint)))
