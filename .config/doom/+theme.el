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

(defvar my-light-theme 'doom-nord-light)
(defvar my-dark-theme 'doom-nord-aurora)

(setq doom-theme my-dark-theme)


(setq doom-themes-enable-bold t
      doom-themes-enable-italic nil)

(setq display-line-numbers-type 'relative
      doom-themes-enable-italic nil)

(let ((my-font-name (if (eq system-type 'windows-nt)
                        "ZedMono NF"
                      "JetBrainsMono Nerd Font")))
  (setq doom-font (font-spec :family my-font-name :size 17)
        doom-variable-pitch-font (font-spec :family my-font-name :size 17)
        doom-big-font (font-spec :family my-font-name :size 24)))

(defun toggle-emacs-opacity-90 ()
  "Toggle background transparency."
  (interactive)
  (let ((current-alpha (frame-parameter nil 'alpha-background)))
    (if (or (not current-alpha) (= current-alpha 100))
        (set-frame-parameter nil 'alpha-background 90)
      (set-frame-parameter nil 'alpha-background 100))))

(defun toggle-emacs-opacity-70 ()
  "Toggle background transparency."
  (interactive)
  (let ((current-alpha (frame-parameter nil 'alpha-background)))
    (if (or (not current-alpha) (= current-alpha 100))
        (set-frame-parameter nil 'alpha-background 70)
      (set-frame-parameter nil 'alpha-background 100))))

(add-to-list 'default-frame-alist '(alpha-background . 90))

(map! :leader
      :desc "Toggle editor opacity"
      "w O" #'toggle-emacs-opacity-70)

(map! :leader
      :desc "Toggle editor opacity"
      "w o" #'toggle-emacs-opacity-90)

(defun my/toggle-theme ()
  (interactive)
  (if (eq doom-theme my-dark-theme)
      (setq doom-theme my-light-theme)
    (setq doom-theme my-dark-theme))
  (load-theme doom-theme t))

(map! :leader
      :desc "Toggle light/dark theme"
      "t d" #'my/toggle-theme)
