;;; $DOOMDIR/modules/+lsp.el -*- lexical-binding: t; -*-

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



;; Check type definition
(map! :leader
      :desc "Peek docs"
      "c g" #'lsp-ui-doc-glance)

(map! :leader
      :desc "View docs"
      "c G" #'lsp-describe-thing-at-point)

(setq lsp-ui-doc-max-height 50)

(company-quickhelp-mode)
(setq company-quickhelp-delay 0)

-(setq evil-insert-state-cursor 'box)
