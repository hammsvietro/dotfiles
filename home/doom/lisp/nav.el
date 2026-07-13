;;; lisp/nav.el -*- lexical-binding: t; -*-
;;; Completion (ivy/corfu) and project navigation.

(setq projectile-track-known-projects-automatically nil)
(setq projectile-enable-caching nil)

(after! ivy
  (setq ivy-re-builders-alist
        '((projectile-find-file . ivy--regex-ignore-order)
          (+ivy/projectile-find-file . ivy--regex-ignore-order)
          (counsel-rg . ivy--regex-ignore-order)
          (t . ivy--regex-plus)))

  (ivy-add-actions
   'counsel-find-file
   '(("v" (lambda (x)
            (select-window (split-window-right))
            (find-file x))
      "Open in vertical split")))

  (ivy-add-actions
   'ivy-switch-buffer
   '(("v" (lambda (x)
            (select-window (split-window-right))
            (switch-to-buffer x))
      "Open in vertical split"))))

(after! corfu
  (setq corfu-preselect 'first))

;; Trigger completion-at-point manually (TAB is reserved for indentation; see editor.el).
(map! :i "C-SPC" #'completion-at-point
      :n "C-SPC" #'completion-at-point)
