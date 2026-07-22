;;; lisp/editor.el -*- lexical-binding: t; -*-
;;; Evil tweaks and general editing keys/commands.

;; Treat _ as part of a word (motions, text objects).
(modify-syntax-entry ?_ "w")
(advice-add 'evil-inner-word :around
            (lambda (orig &rest args)
              (let ((table (copy-syntax-table (syntax-table))))
                (modify-syntax-entry ?_ "w" table)
                (with-syntax-table table
                  (apply orig args)))))

(setq evil-kill-on-visual-paste nil)
;; Block cursor in insert mode.
(setq evil-insert-state-cursor 'box)

;; Similar to vim's 'scrolloff'.
(setq scroll-margin 7)

;; Restore vim 's' (substitute) by dropping evil-snipe.
(remove-hook 'doom-first-input-hook #'evil-snipe-mode)

(evil-set-undo-system 'undo-redo)

(map! :n "TAB" #'better-jumper-jump-forward)

(map! :leader
      :desc "Go to definition on split"
      "g d" #'xref-find-definitions-other-window)

(defun my/downcase-upper-only (beg end)
  "Downcase all completely UPPERCASE words in the active region."
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region beg end)
      (goto-char (point-min))
      (while (re-search-forward "\\w+" nil t)
        (let ((word (match-string 0)))
          (when (and (string= word (upcase word))
                     (not (string= word (downcase word))))
            (replace-match (downcase word) t t)))))))

(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

(map! :leader
      :desc "Toggle window split"
      "w t" #'toggle-window-split)

(defun my/shift-tab ()
  (interactive)
  (indent-rigidly (line-beginning-position) (line-end-position) (- tab-width)))

;; TAB indents, never completes (completion is on C-SPC; see nav.el).
(map! :i "TAB" #'tab-to-tab-stop
      :i "<tab>" #'tab-to-tab-stop
      :i "<backtab>" #'my/shift-tab)

(after! corfu
  (map! :map corfu-map
        "TAB" #'tab-to-tab-stop
        "<tab>" #'tab-to-tab-stop
        "<backtab>" #'my/shift-tab))
