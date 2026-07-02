;;; lisp/ui.el -*- lexical-binding: t; -*-
;;; Chrome: splash, ibuffer, modeline, treemacs, frame title, workspaces.

(setq fancy-splash-image "~/.config/doom/images/knight.png")
(setq frame-title-format "Emacs")

;; Don't truncate the package name in the emacs-lisp modeline/pin.
(advice-add '+emacs-lisp-truncate-pin :override (lambda () ()))

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

;; FIX: diff-hl's async gutter update spawns a `git diff' process and parses its
;; output in a process sentinel via `diff-hl-changes-from-buffer'. When a large
;; file is written/reverted rapidly (e.g. Claude applying edits), overlapping
;; flydiff refreshes leave the diff buffer without a valid hunk header, so
;; `diff-beginning-of-hunk' signals "Can't find the beginning of the hunk"
;; inside the sentinel and the idle timer re-fires it non-stop. Treat an
;; unparseable diff as "no changes" instead of erroring.
(after! diff-hl
  (advice-add 'diff-hl-changes-from-buffer :around
              (lambda (orig buf)
                (condition-case nil
                    (funcall orig buf)
                  (error nil)))))
