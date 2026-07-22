;;; lisp/org.el -*- lexical-binding: t; -*-
;;; Org directories, capture templates, and autosave.

(after! org
  (setq org-directory "~/org/")
  (setq org-roam-directory "~/org/roam/")
  (setq org-agenda-files (list "~/org/"
                               "~/org/roam/daily/"))

  ;; Consistent TODO keywords — matches beorg's init.org declaration
  (setq org-todo-keywords
        '((sequence "TODO(t)" "DOING(o)" "BLOCKED(b)" "|" "DONE(d)" "CANCELLED(c)")))

  (setq org-capture-templates
        `(("i" "Inbox" entry (file "~/org/inbox.org")
           "* TODO %?\n%U" :prepend t)

          ("j" "Journal")
          ("jj" "Quick Journal" entry
           (file+olp+datetree "~/org/journal.org")
           "* %(format-time-string \"%H:%M\") %?")
          ("jc" "Journal with Context" entry
           (file+olp+datetree "~/org/journal.org")
           "* %(format-time-string \"%H:%M\") %?\n  Context: %a")
          ("jf" "Fullscreen Journal" entry
           (file+olp+datetree "~/org/journal.org")
           "* %(format-time-string \"%H:%M\") %?"
           :unnarrowed t
           :custom-fullscreen t)))

  (add-hook 'org-capture-mode-hook
            (lambda ()
              (when (org-capture-get :custom-fullscreen)
                (run-with-timer 0.05 nil
                                (lambda ()
                                  (when (fboundp '+popup/raise)
                                    (+popup/raise (selected-window)))
                                  (delete-other-windows)))))))

(defconst my/daily-head
  (concat "#+title: %<%Y-%m-%d>\n"
          "#+STARTUP: show2levels\n\n"
          "* Plan\n"
          "* Tasks\n"
          "* Log\n"
          "* Notes\n")
  )

(defun my/org-roam-daily-skeleton ()
  "Insert the Plan/Tasks/Log/Notes skeleton when a daily note is newly created.
Runs via `org-roam-dailies-find-file-hook', which fires for both
`org-roam-dailies-goto-today' (SPC n r d t) and the capture path.
Guards against touching existing dailies by checking for any level-1 heading."
  (when (and buffer-file-name
             (bound-and-true-p org-roam-directory)
             (string-prefix-p
              (expand-file-name "daily/" org-roam-directory)
              (expand-file-name buffer-file-name))
             ;; Only act when the file has no level-1 headings yet
             (not (save-excursion
                    (goto-char (point-min))
                    (re-search-forward "^\\* " nil t))))
    ;; Insert #+title: if org-roam hasn't added one yet
    (unless (save-excursion
              (goto-char (point-min))
              (re-search-forward "^#\\+title:" nil t))
      (save-excursion
        (goto-char (point-min))
        ;; Step past the :PROPERTIES: … :END: block if present
        (when (re-search-forward "^:END:" nil t)
          (forward-line 1))
        (insert (format-time-string "#+title: %Y-%m-%d\n#+STARTUP: show2levels\n\n"))))
    ;; Append the four section headings
    (goto-char (point-max))
    (unless (bolp) (insert "\n"))
    (insert "* Plan\n* Tasks\n* Log\n* Notes\n")
    (save-buffer)
    ;; Land the cursor at the Plan heading so the user can start typing
    (goto-char (point-min))
    (re-search-forward "^\\* Plan" nil t)))

(after! org-roam
  (setq org-roam-dailies-capture-templates
        `(("d" "note → Notes" entry "* %?"
           :target (file+head+olp "%<%Y-%m-%d>.org" ,my/daily-head ("Notes")))
          ("t" "task → Tasks" entry "* TODO %?\nSCHEDULED: %t"
           :target (file+head+olp "%<%Y-%m-%d>.org" ,my/daily-head ("Tasks")))
          ("l" "log → Log" entry "* %<%H:%M> %?"
           :target (file+head+olp "%<%Y-%m-%d>.org" ,my/daily-head ("Log")))
          ("p" "plan bullet → Plan" item "- %?"
           :target (file+head+olp "%<%Y-%m-%d>.org" ,my/daily-head ("Plan")))))

  (add-hook 'org-roam-dailies-find-file-hook #'my/org-roam-daily-skeleton))

(setq org-agenda-custom-commands
      '(("d" "Day view + unscheduled inbox"
         ((agenda "" ((org-agenda-span 1)))
          (todo "TODO"
                ((org-agenda-files '("~/org/inbox.org"))
                 (org-agenda-overriding-header "── Inbox (unscheduled) ──")))))))

(setq org-agenda-skip-unavailable-files t)

(defun my/org-save-all-after-change (&rest _)
  (org-save-all-org-buffers))

(advice-add 'org-deadline :after #'my/org-save-all-after-change)
(advice-add 'org-schedule :after #'my/org-save-all-after-change)
(advice-add 'org-todo     :after #'my/org-save-all-after-change)

(add-hook 'org-capture-after-finalize-hook 'org-save-all-org-buffers)
(add-hook 'org-mode-hook (lambda () (save-place-local-mode -1)))

(custom-set-faces!
  '(org-level-1 :height 1.15 :weight bold)
  '(org-level-2 :height 1.10 :weight bold)
  '(org-level-3 :height 1.05 :weight bold))
