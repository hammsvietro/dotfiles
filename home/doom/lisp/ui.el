;;; lisp/ui.el -*- lexical-binding: t; -*-

(setq fancy-splash-image "~/.config/doom/images/knight.png")
(setq frame-title-format "Emacs")

;; Don't truncate the package name in the emacs-lisp modeline/pin.
(advice-add '+emacs-lisp-truncate-pin :override #'ignore)

;; Wider ibuffer columns (name 30s were originally 18s).
(setq ibuffer-formats
      '((mark modified read-only " "
         (name 35 35 :left :elide)
         " "
         (size 9 -1 :right)
         " "
         (mode 16 16 :left :elide)
         " " filename-and-process)
        (mark " "
              (name 16 -1)
              " " filename)))

(setq doom-modeline-vcs-max-length 30)

(setq treemacs-position 'right)
(setq treemacs-git-mode 'deferred)

;; Reuse the main workspace for new emacsclient frames instead of spawning one.
(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override "main"))

(map! :leader
      :desc "Toggle Treemacs"
      "f x" #'+treemacs/toggle)

(map! :leader
      :desc "Open project ibuffer"
      "b P" #'projectile-ibuffer)

;; Treat an unparseable diff as "no changes" so rapid file writes don't loop on
;; diff-hl's "Can't find the beginning of the hunk" error.
(after! diff-hl
  (advice-add 'diff-hl-changes-from-buffer :around
              (lambda (orig buf)
                (condition-case nil
                    (funcall orig buf)
                  (error nil)))))
