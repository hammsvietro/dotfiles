;;; lisp/org.el -*- lexical-binding: t; -*-
;;; Org directories, capture templates, and autosave.

(after! org
  (setq org-directory "~/org/")
  (setq org-roam-directory "~/org/roam/")
  (setq org-agenda-files (list "~/org/" 
                               "~/org/roam/daily/"))
  (setq org-capture-templates
        '(("j" "Journal")
          ("jj" "Quick Journal" entry
           (file+olp+datetree "~/org/journal.org")
           "* %(format-time-string \"%H:%M\") %?"
           )
          ("jc" "Journal with Context" entry
           (file+olp+datetree "~/org/journal.org")
           "* %(format-time-string \"%H:%M\") %?\n  Context: %a"
           )
          ("jf" "Fullscreen Journal" entry
           (file+olp+datetree "~/org/journal.org")
           "* %(format-time-string \"%H:%M\") %?"
           :unnarrowed t
           :custom-fullscreen t
           )))

  (add-hook 'org-capture-mode-hook
            (lambda ()
              (when (org-capture-get :custom-fullscreen)
                (run-with-timer 0.05 nil
                                (lambda ()
                                  (when (fboundp '+popup/raise)
                                    (+popup/raise (selected-window)))
                                  (delete-other-windows))))))
  )

(custom-set-faces!
  '(org-level-1 :height 1.15 :weight bold)
  '(org-level-2 :height 1.1 :weight bold)
  '(org-level-3 :height 1.05 :weight bold)
  '(org-level-3 :height 1.0 :weight bold))

(setq org-agenda-skip-unavailable-files t)
(defun my/org-save-all-after-change (&rest _)
  (org-save-all-org-buffers))

(advice-add 'org-deadline :after #'my/org-save-all-after-change)
(advice-add 'org-schedule :after #'my/org-save-all-after-change)
(advice-add 'org-todo :after #'my/org-save-all-after-change)

(add-hook 'org-capture-after-finalize-hook 'org-save-all-org-buffers)
(add-hook 'org-mode-hook (lambda () (save-place-local-mode -1)))
