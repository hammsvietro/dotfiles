;;; $DOOMDIR/+evil.el -*- lexical-binding: t; -*-

;; Make _ as part of the word
(modify-syntax-entry ?_ "w")

(defadvice evil-inner-word (around underscore-as-word activate)
  (let ((table (copy-syntax-table (syntax-table))))
    (modify-syntax-entry ?_ "w" table)
    (with-syntax-table table
      ad-do-it)))

;; restore vim 'Y' functionality (yank rest of the line)
(setq! evil-want-Y-yank-to-eol nil)


;; Block cursor on insert mode
(setq evil-insert-state-cursor 'box)

;; restore vim 's' functionality (substitute)
(remove-hook 'doom-first-input-hook #'evil-snipe-mode)

;; Fix undo system
(evil-set-undo-system 'undo-redo)

;; Open definition in other window
(map! :leader
      :desc "Go to definition on split"
      "g d" #'xref-find-definitions-other-window)
