;;; lisp/emacs-lisp.el -*- lexical-binding: t; -*-
;;; Workaround for an upstream Doom bug (doomemacs/modules commit 8ee60ce0d):
;;; a `,(read ...)' unquote was placed outside its backtick in
;;; `+emacs-lisp--flycheck-non-package-mode', so opening a non-package .el file
;;; under flycheck signals (void-function \,). That aborts emacs-lisp-mode's
;;; hook before font-lock is enabled, leaving .el buffers unhighlighted.
;;;
;;; Redefine the mode with the quasiquote corrected (condition-case + spliced
;;; prior check-form wrapped in one backticked progn). Runs after the module's
;;; buggy definition loads, so it wins. Drop this file once upstream is fixed.

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
