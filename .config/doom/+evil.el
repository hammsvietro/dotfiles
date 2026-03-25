;;; $DOOMDIR/+evil.el -*- lexical-binding: t; -*-

;; Make _ as part of the word
(modify-syntax-entry ?_ "w")

(defadvice evil-inner-word (around underscore-as-word activate)
  (let ((table (copy-syntax-table (syntax-table))))
    (modify-syntax-entry ?_ "w" table)
    (with-syntax-table table
      ad-do-it)))

;; Block cursor on insert mode
(setq evil-insert-state-cursor 'box)

;; Similar to vim's 'scrolloff'
(setq scroll-margin 7)

;; restore vim 's' functionality (substitute)
(remove-hook 'doom-first-input-hook #'evil-snipe-mode)

;; Fix undo system
(evil-set-undo-system 'undo-redo)


(map! :n "TAB" #'better-jumper-jump-forward)

;; Open definition in other window
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

(map! :i "TAB" #'tab-to-tab-stop
      :i "<tab>" #'tab-to-tab-stop
      :i "<backtab>" #'my/shift-tab)

(after! corfu
  (map! :map corfu-map
        "TAB" #'tab-to-tab-stop
        "<tab>" #'tab-to-tab-stop
        "<backtab>" #'my/shift-tab))
