;;; ../../dotfiles/.config/doom/+org.el -*- lexical-binding: t; -*-

(setq-default gac-automatically-push-p t)
(setq-default gac-automatically-add-new-files-p t)
(setq gac-default-message "Auto-commit: Org notes update")

(use-package! git-auto-commit-mode
  :hook (org-mode . git-auto-commit-mode))

(after! org
  (setq org-directory "~/org/")
  (setq org-roam-directory "~/org/roam/")
  (setq org-agenda-files (list "~/org/journal.org" 
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
