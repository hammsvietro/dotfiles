;;; lisp/lsp.el -*- lexical-binding: t; -*-
;;; LSP, flycheck, formatting, and per-language dev config.

(use-package! lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp)))
  :config
  (setq lsp-pyright-auto-search-paths t))

;; Honor a project's pyrightconfig.json "exclude" list for LSP file watchers.
(add-hook 'lsp-mode-hook
	  (lambda ()
	    (let* ((root (lsp--workspace-root (cl-first (lsp-workspaces))))
		   (pyright-config (concat root "/pyrightconfig.json"))
		   (default-ignored (eval (car (get 'lsp-file-watch-ignored-directories 'standard-value)))))
	      (if (file-exists-p pyright-config)
		  (progn
		    (setq lsp-enable-file-watchers t)
		    (setq lsp-file-watch-ignored-directories default-ignored)
		    (require 'json)
		    (let* ((json-object-type 'hash-table)
			   (json-array-type 'list)
			   (json-key-type 'string)
			   (json (json-read-file pyright-config))
			   (exclude (gethash "exclude" json)))
		      (dolist (exclud exclude)
			(push exclud lsp-file-watch-ignored))))
		(setq lsp-enable-file-watchers 'nil)
		(setq lsp-file-watch-ignored-directories default-ignored)))))

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

;; Run ESLint after LSP for TypeScript/TSX.
(after! flycheck
  (flycheck-add-mode 'javascript-eslint 'tsx-ts-mode)
  (flycheck-add-mode 'javascript-eslint 'typescript-ts-mode)

  (defun my-setup-typescript-flycheck-chain ()
    "Link LSP to ESLint for TypeScript/TSX."
    (flycheck-add-next-checker 'lsp 'javascript-eslint))

  (add-hook 'lsp-managed-mode-hook #'my-setup-typescript-flycheck-chain))

(after! rustic
  (setq lsp-rust-analyzer-cargo-extraEnv
        '(("CFLAGS" . "-O2 -D_FORTIFY_SOURCE=0"))))

(setq read-process-output-max (* 1024 1024)) ;; 1MB
(setq gc-cons-threshold (* 100 1024 1024)) ;; 100MB

(setq-hook! '(typescript-ts-mode-hook tsx-ts-mode-hook)
  typescript-ts-mode-indent-offset 4)

(after! apheleia
  (add-to-list 'apheleia-mode-alist '(js-ts-mode . lsp))
  (add-to-list 'apheleia-mode-alist '(typescript-ts-mode . lsp))
  (add-to-list 'apheleia-mode-alist '(tsx-ts-mode . lsp)))

(setq-default +format-with-lsp nil)
(setq-hook! '(js-ts-mode-hook) +format-with-lsp t)
