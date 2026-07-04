;;; $DOOMDIR/packages.el

(package! copilot
  :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el")))

(package! kanagawa-themes)

(package! ember-theme
  :recipe (:host github :repo "ember-theme/emacs"))

(package! shell-maker)
(package! acp)
(package! agent-shell)
