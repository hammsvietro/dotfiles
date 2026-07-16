# dotfiles

Pedro's NixOS + Home Manager + Doom Emacs configuration (flake-based).

Priorities, in order: **security, reproducibility, performance.** Every change is
measured against them — see [Priorities](#priorities).

## Layout

- `flake.nix` — entry point. `mkHost` builds `nixosConfigurations.{fractal,mandelbrot}`;
  each pulls in Home Manager as a NixOS module for user `hammsvietro`. Inputs include
  `nixpkgs` (unstable), `home-manager`, `sops-nix`, `rust-overlay`, `zen-browser`, `noctalia`.
- `hosts/<name>/` — per-machine: `hardware-configuration.nix`, host-specific hardware
  (e.g. `nvidia-desktop.nix`), hostname. Imports `../../modules`.
- `modules/` — system config, aggregated by `modules/default.nix` and grouped by concern:
  `system/`, `desktop/`, `hardware/`, `services/`, `programs/`, `users/`.
- `home/` — Home Manager, entry `home.nix` importing the per-concern modules
  (`hyprland shell git terminal files theming greeter blackwall secrets mime`). Also holds
  the raw app configs it symlinks out-of-store: `home/doom/` and `home/zed/`.
- `home/doom/` — Doom Emacs. `config.el` loads the `lisp/*.el` modules
  (`ui theme editor nav lsp emacs-lisp ai org`); `init.el` = enabled Doom modules,
  `packages.el` = extra packages.
- `dev-flakes/` — per-project dev shells (direnv): `timeseer/`, `ts-flows/`.
- `secrets/` — sops/age-encrypted material (see [Secrets](#secrets)).

Desktop is Hyprland (Wayland) with the noctalia shell; Plasma is also available.

## Commands

- **Rebuild the system:** `sudo nixos-rebuild switch --flake ~/dotfiles#fractal`
  (`#mandelbrot` on the laptop). **Nix changes only take effect after this.** The `/rebuild`
  slash command runs it for the current host.
- **Dry run / validate:** `nixos-rebuild dry-build --flake ~/dotfiles#<host>` or `nix flake check`.
- **Emacs packages:** `~/.config/emacs/bin/doom sync` after editing `packages.el`, then
  restart Emacs. `doom purge` GCs orphaned build dirs.
- **Secret scan:** `/secret-scan`, or `gitleaks git -c ~/dotfiles/.gitleaks.toml ~/dotfiles`.

## Secrets

Secrets are encrypted in-repo with **sops-nix** (age). There is no plaintext secret file —
the old `~/.secrets.sh` gap is closed.

- `secrets/construct.yaml` — sops-encrypted vault (values `ENC[...]`; only key *names* are
  cleartext). `home/secrets.nix` enumerates those key names at eval time, declares each as a
  sops secret, and renders them into the `construct.env` template (`KEY=<value>` lines). Add
  a secret with `sops secrets/construct.yaml`; no Nix edit is needed to wire a new key.
- `home/shell.nix` sources `construct.env` at interactive-shell startup and exports each var.
- `secrets/blackwall.enc` — a separate raw-age tar blob (`blackwall-lock` / `blackwall-unlock`
  wrap the `age` CLI); the decrypted vault lives outside the repo and `/blackwall/` is gitignored.
- The age private key lives at `~/.config/sops/age/keys.txt` and is **never** in the repo.
  Its public recipient in `.sops.yaml` is safe to commit.

## Working with Claude here

Guardrails are defined in Nix and reproduced by `nixos-rebuild` — nothing is installed by
hand. Scripts live in `home/claude-hooks/` and are built into the generated Claude
`settings.json` by `home/files.nix` (via `home/claude-hooks.nix`). **They act only inside
`~/dotfiles`** (each script early-exits elsewhere) and apply to both the personal and work
Claude configs.

- **Secret gate** (`secret-guard`) — `gitleaks` runs before every `git commit`/`git push`
  and again when a turn ends ("check for leaked keys before finishing"). A `.git/hooks/pre-commit`
  symlink runs the same scan on manual commits. Allowlist genuine false positives in `.gitleaks.toml`.
- **Reproducibility gate** (`repro-guard`) — denies imperative installs (`nix-env -i`,
  `npm i -g`, `pipx/cargo/gem/go install`, `pip install --user`, `--break-system-packages`).
  Venv-local `pip install` (the `dev-flakes/` workflow) stays allowed. Install software by
  adding it to a Nix module instead.
- **Secret-write gate** (`secret-write-guard`) — refuses writes into the age key, the
  decrypted blackwall vault, or plaintext under `secrets/`. Edit encrypted files with `sops`.
- **Nix formatter** (`nix-fmt`) — runs `nixfmt` (RFC style) on edited `.nix` files.

## Priorities

**Reproducibility and security come first.** The goal is a bare-metal reinstall that reaches
a fully working machine with a single `nixos-rebuild switch --flake ~/dotfiles#<host>` —
nothing done by hand afterward.

Reproducibility:
- Everything declarative. Install software by adding it to the right Nix module — **never**
  `nix-env -i`, `npm install -g`, `pip install` (outside a venv), or other imperative,
  unrecorded state. If a tool isn't in nixpkgs, package it in the flake (`dev-flakes/` or an
  overlay), don't install it out of band.
- Keep `flake.lock` committed; pin inputs there. Home Manager owns dotfiles so they're
  restored on a fresh machine.
- When adding a dependency, ask: "does a clean checkout + one rebuild reproduce this?" If not,
  it's not done.

Security:
- **Never commit secrets** — API keys, tokens, passwords. Prefer login/OAuth or runtime
  lookups over inline values (e.g. Emacs agent-shell uses `:login t`, not an API key in the
  repo; dev-flake creds come from the sops-rendered env).
- New secrets go into `secrets/construct.yaml` via sops — never plaintext. The `gitleaks`
  gate is a backstop, not permission to be careless.

## Conventions

### Comments — keep them minimal

Default to **no comments**. Nix attribute names and Elisp are self-documenting; restating
what code does is noise. Match the surrounding file: most Nix modules have zero comments,
Emacs lisp has only occasional one-liners.

**No decorative or organizational comments — anywhere.** No section labels (`# Editors`,
`# Go Deps`), no commented-out code (delete it; git remembers), and no annotating package
additions (no `claude-agent-acp # bridge for X`) — a bare entry is what's wanted even when
its purpose isn't self-evident. Group with blank lines, not headings.

A comment is warranted **only** when the *why* isn't obvious from the code — a workaround, an
ordering constraint, or an upstream quirk (e.g. "guitarix must run under pw-jack or it
segfaults"). This is rare and applies in Nix too, but Nix is almost always self-documenting,
so the bar there is very high. Examples of the acceptable style already in the tree
(`lisp/editor.el`, `lisp/ai.el`, `modules/hardware/audio.nix`):

```elisp
;; Similar to vim's 'scrolloff'.
(setq scroll-margin 7)
;; TAB indents, never completes (completion is on C-SPC; see nav.el).
```

Rules:
- One line, placed above the code. No block/banner comments.
- Never narrate a change or diff (`;; added X`, `;; changed from Y`).
- Never restate the obvious (`;; set the theme` above a theme setting).
- Emacs lisp modules keep their `;;; lisp/x.el -*- lexical-binding: t; -*-` header and
  one-line description — that header is the convention, not extra commentary.
- When in doubt, leave it out.

> The `home/claude-hooks/*.sh` files are the one exception: they carry a short header comment
> because they run in an opaque hook context (stdin JSON, `writeShellApplication` wrapping)
> that isn't self-evident.
