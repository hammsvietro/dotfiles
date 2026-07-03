;;; lisp/emacs-lisp.el -*- lexical-binding: t; -*-
;;; Redefine +emacs-lisp--flycheck-non-package-mode with its quasiquote fixed;
;;; upstream (doomemacs/modules 8ee60ce0d) misplaced an unquote, breaking
;;; font-lock in non-package .el buffers. Drop once fixed upstream.

(with-eval-after-load "modules/lang/emacs-lisp/autoload/emacs-lisp"
  (define-minor-mode +emacs-lisp--flycheck-non-package-mode
    ""
    (if (not +emacs-lisp--flycheck-non-package-mode)
        (when (get 'flycheck-disabled-checkers 'initial-value)
          (setq-local flycheck-disabled-checkers (get 'flycheck-disabled-checkers 'initial-value))
          (kill-local-variable 'flycheck-emacs-lisp-check-form))
      (with-memoization (get 'flycheck-disabled-checkers 'initial-value)
        flycheck-disabled-checkers)
      (setq-local flycheck-emacs-lisp-check-form
                  (prin1-to-string
                   `(progn
                      (condition-case e
                          (progn
                            (require 'doom)
                            (require 'doom-cli)
                            (doom-initialize ,(doom-profile->id doom-profile))
                            (setq doom-profile ',doom-profile
                                  doom-modules ',doom-modules
                                  doom-disabled-packages ',doom-disabled-packages
                                  byte-compile-warnings ',+emacs-lisp-linter-warnings)
                            (doom-startup))
                        (error
                         (princ
                          (format "%s:%d:%d:Error:Failed to load Doom: %s\n"
                                  (or ,(ignore-errors
                                         (file-name-nondirectory
                                          (buffer-file-name (buffer-base-buffer))))
                                      (car command-line-args-left))
                                  0 0 (error-message-string e)))))
                      ,(read (default-toplevel-value 'flycheck-emacs-lisp-check-form))))
                  flycheck-disabled-checkers
                  (cons 'emacs-lisp-checkdoc
                        (remq 'emacs-lisp-checkdoc
                              flycheck-disabled-checkers))))))
