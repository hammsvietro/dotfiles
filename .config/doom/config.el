;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; `load-theme' function. This is the default:
(setq doom-theme 'doom-ir-black)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(setq doom-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 15)
      doom-variable-pitch-font (font-spec :family "Ubuntu" :size 15)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 24))


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Open file tree
(map! :leader
      :desc "Toggle Treemacs"
      "f x" #'treemacs)

;; Open project ibuffer
(map! :leader
      :desc "Open project ibuffer"
      "b P" #'projectile-ibuffer)


;; avoid truncating strings
(advice-add '+emacs-lisp-truncate-pin :override (lambda () ()) )

(setq fancy-splash-image "~/.config/doom/images/knight.png")

;; increase ibuffer column widths
(setq ibuffer-formats
      '((mark modified read-only " "
         (name 35 35 :left :elide) ; change: 30s were originally 18s
         " "
         (size 9 -1 :right)
         " "
         (mode 16 16 :left :elide)
         " " filename-and-process)
        (mark " "
              (name 16 -1)
              " " filename)))

(setq doom-modeline-vcs-max-length 30)

(load! "+lsp.el")
(load! "+evil.el")

(setq frame-title-format "Emacs")
(setq treemacs-git-mode 'deferred)
(setq projectile-track-known-projects-automatically nil)

;; Discord presence
(require 'elcord)
(elcord-mode)
(setq elcord-editor-icon "emacs_icon")
