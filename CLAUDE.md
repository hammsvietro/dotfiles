# dotfiles

Pedro's NixOS + Home Manager + Doom Emacs configuration (flake-based).

## Layout

- `flake.nix` — entry point. `mkHost` builds `nixosConfigurations.{fractal,mandelbrot}`;
  each pulls in Home Manager as a NixOS module for user `hammsvietro`.
- `hosts/<name>/` — per-machine: `hardware-configuration.nix`, host-specific
  hardware (e.g. `nvidia-desktop.nix`), hostname. Imports `../../modules`.
- `modules/` — system config, aggregated by `modules/default.nix` and grouped by
  concern: `system/`, `desktop/`, `hardware/`, `services/`, `programs/`, `users/`.
- `home/` — Home Manager, entry `home.nix` importing
  `hyprland/shell/git/terminal/files/mime`. Also holds the raw app configs it
  symlinks out-of-store: `home/doom/` and `home/zed/`.
- `home/doom/` — Doom Emacs. `config.el` loads the `lisp/*.el` modules
  (`ui theme editor nav lsp ai org`); `init.el` = enabled Doom modules,
  `packages.el` = extra packages.
- `dev-flakes/` — per-project dev shells (direnv).

Desktop is Hyprland (Wayland) with the noctalia shell; Plasma is also available.

## Commands

- Rebuild system: `sudo nixos-rebuild switch --flake ~/dotfiles#fractal`
  (use `#mandelbrot` on the laptop). Nix changes only take effect after this.
- Emacs packages: `~/.config/emacs/bin/doom sync` after editing `packages.el`,
  then restart Emacs. `doom purge` GCs orphaned build dirs.

## Priorities

**Reproducibility and security come first.** The goal is a bare-metal reinstall
that reaches a fully working machine with a single
`nixos-rebuild switch --flake ~/dotfiles#<host>` — nothing done by hand afterward.

Reproducibility:
- Everything declarative. Install software by adding it to the right Nix module —
  **never** `nix-env -i`, `npm install -g`, `pip install`, or other imperative,
  unrecorded state. If a tool isn't in nixpkgs, package it in the flake
  (`dev-flakes/` or an overlay), don't install it out of band.
- Keep `flake.lock` committed; pin inputs there. Home Manager owns dotfiles so
  they're restored on a fresh machine.
- When adding a dependency, ask: "does a clean checkout + one rebuild reproduce
  this?" If not, it's not done.

Security:
- **Never commit secrets** — API keys, tokens, passwords. Prefer login/OAuth or
  runtime lookups over inline values (e.g. Emacs agent-shell uses `:login t`, not
  an API key in the repo; dev-flake creds come from env vars).
- Current pattern: secrets live outside the repo in `~/.secrets.sh` (sourced by
  `shell.nix`). This is the one non-reproducible gap — the migration target is
  **sops-nix** so encrypted secrets can live in the flake (see the TODO in
  `home/shell.nix`). Move new secrets toward that, not into
  plaintext.

## Conventions

### Comments — keep them minimal

Default to **no comments**. Nix attribute names and Elisp are self-documenting;
restating what code does is noise. Match the surrounding file: most Nix modules
have zero comments, Emacs lisp has only occasional one-liners.

**No decorative or organizational comments — anywhere.** No section labels
(`# Editors`, `# Go Deps`), no commented-out code (delete it; git remembers), and
no annotating package additions (no `claude-agent-acp # bridge for X`) — a bare
entry is what's wanted even when its purpose isn't self-evident. Group with blank
lines, not headings.

A comment is warranted **only** when the *why* isn't obvious from the code — a
workaround, an ordering constraint, or an upstream quirk (e.g. "guitarix must run
under pw-jack or it segfaults"). This is rare and applies in Nix too, but Nix is
almost always self-documenting, so the bar there is very high. Examples of the
acceptable style already in the tree (`lisp/editor.el`, `lisp/ai.el`,
`modules/hardware/audio.nix`):

```elisp
;; Similar to vim's 'scrolloff'.
(setq scroll-margin 7)
;; TAB indents, never completes (completion is on C-SPC; see nav.el).
```

Rules:
- One line, placed above the code. No block/banner comments.
- Never narrate a change or diff (`;; added X`, `;; changed from Y`).
- Never restate the obvious (`;; set the theme` above a theme setting).
- Emacs lisp modules keep their `;;; lisp/x.el -*- lexical-binding: t; -*-` header
  and one-line description — that header is the convention, not extra commentary.
- When in doubt, leave it out.
