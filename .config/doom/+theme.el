;;; ../../dotfiles/.config/doom/+theme.el -*- lexical-binding: t; -*-


;; (require 'filenotify)
;; (let ((theme-dir (expand-file-name "~/.config/emacs/themes/")))
;;   (file-notify-add-watch
;;    theme-dir
;;    '(change)
;;    (lambda (event)
;;      ;; Check if the changed file is actually the noctalia theme
;;      (when (string-match-p "noctalia" (nth 2 event))
;;        (message "Noctalia theme update detected, reloading...")
;;        ;; Use 'no-confirm' to prevent Emacs from asking if the theme is "safe"
;;        (load-theme 'noctalia t)))))

;; (setq doom-theme 'doom-gruvbox)
(setq doom-theme 'catppuccin)


(setq doom-themes-enable-bold t
      doom-themes-enable-italic nil)

(setq display-line-numbers-type 'relative
      doom-themes-enable-italic nil)

(setq doom-font (font-spec :family "ZedMono Nerd Font" :size 17)
      doom-variable-pitch-font (font-spec :family "ZedMono Nerd Font" :size 17)
      doom-big-font (font-spec :family "ZedMono Nerd Font" :size 24))

