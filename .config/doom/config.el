;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;;;
;;; Table of contents. Each module below owns its own settings, commands, and
;;; keybindings. See init.el for enabled Doom modules and packages.el for extra
;;; packages.

(load! "lisp/ui")       ; chrome: splash, ibuffer, modeline, treemacs, workspaces
(load! "lisp/theme")    ; themes, fonts, line numbers, opacity
(load! "lisp/editor")   ; evil tweaks + general editing keys/commands
(load! "lisp/nav")      ; completion (ivy/corfu) + project navigation
(load! "lisp/lsp")      ; LSP, flycheck, formatting, per-language dev config
(load! "lisp/emacs-lisp") ; workaround for upstream elisp flycheck-mode bug
(load! "lisp/ai")       ; Copilot, Claude Code (agent-shell)
(load! "lisp/org")      ; org directories, capture, autosave
