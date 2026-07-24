;;; lisp/theme.el -*- lexical-binding: t; -*-
;;; Themes, fonts, line numbers, and opacity toggles.

(let ((custom-theme-path (expand-file-name "~/.config/emacs/.local/straight/repos/emacs/")))
  ;; Only add the path if the directory actually exists on this machine.
  (when (file-directory-p custom-theme-path)
    (add-to-list 'custom-theme-load-path custom-theme-path)))

(defvar my-dark-theme 'doom-ir-black)
(defvar my-light-theme 'doom-nord-light)

(setq doom-theme my-dark-theme)

(setq doom-themes-enable-bold t
      doom-themes-enable-italic nil)

(setq display-line-numbers-type 'relative)

(let ((my-font-name (if (eq system-type 'windows-nt)
                        "ZedMono NF"
                      "JetBrainsMono Nerd Font")))
  (setq doom-font (font-spec :family my-font-name :size 17)
        doom-variable-pitch-font (font-spec :family my-font-name :size 17)
        doom-big-font (font-spec :family my-font-name :size 24)))

(defun my/toggle-opacity (level)
  "Toggle background transparency between LEVEL and full opacity."
  (let ((current-alpha (frame-parameter nil 'alpha-background)))
    (if (or (not current-alpha) (= current-alpha 100))
        (set-frame-parameter nil 'alpha-background level)
      (set-frame-parameter nil 'alpha-background 100))))

(load (expand-file-name "~/.config/doom-glass.el") t t)
(add-to-list 'default-frame-alist
             `(alpha-background . ,(if (boundp 'my/glass-alpha) my/glass-alpha 80)))

(map! :leader
      :desc "Toggle editor opacity"
      "w O" (lambda () (interactive) (my/toggle-opacity 60)))

(map! :leader
      :desc "Toggle editor opacity"
      "w o" (lambda () (interactive) (my/toggle-opacity 80)))

(defun my/toggle-theme ()
  "Toggle between light and dark themes."
  (interactive)
  (let ((new-theme (if (eq doom-theme my-dark-theme)
                       my-light-theme
                     my-dark-theme)))
    (mapc #'disable-theme custom-enabled-themes)
    (setq doom-theme new-theme)
    (load-theme doom-theme t)))

(map! :leader
      :desc "Toggle light/dark theme"
      "t d" #'my/toggle-theme)
