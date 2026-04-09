;;; ../../dotfiles/.config/doom/+org.el -*- lexical-binding: t; -*-

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
  '(org-level-1 :height 1.3 :weight bold)
  '(org-level-2 :height 1.2 :weight bold)
  '(org-level-3 :height 1.1 :weight bold)
  '(org-level-3 :height 1.0 :weight bold))
