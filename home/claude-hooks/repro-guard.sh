# Claude Code hook: reproducibility gate for the dotfiles repo.
# PreToolUse(Bash) denies imperative, unrecorded installs. Venv-local
# `pip install` (the dev-flakes workflow) stays allowed; only clearly global
# forms are blocked.
# Runs under writeShellApplication: bash, `set -euo pipefail`, jq on PATH.

repo="$HOME/dotfiles"
input=$(cat)
cwd=$(jq -r '.cwd // empty' <<<"$input")
dir="${CLAUDE_PROJECT_DIR:-${cwd:-$PWD}}"

case "$dir" in
  "$repo" | "$repo"/*) ;;
  *) exit 0 ;;
esac

cmd=$(jq -r '.tool_input.command // empty' <<<"$input")
[ -n "$cmd" ] || exit 0

deny() {
  echo "Reproducibility guard: $1" >&2
  echo "Install it declaratively instead — add it to the right Nix module (modules/programs/dev.nix, a home.packages list, or a dev-flake) and rebuild. A clean checkout + one rebuild must reproduce the machine." >&2
  exit 2
}

case "$cmd" in
  *"nix-env -i"* | *"nix-env --install"*) deny "'nix-env -i' installs unrecorded profile state." ;;
  *"npm install -g"* | *"npm i -g"* | *"npm install --global"* | *"yarn global add"* | *"pnpm add -g"*) deny "global npm/yarn/pnpm install is not reproducible." ;;
  *"pipx install"*) deny "'pipx install' is unrecorded global state." ;;
  *"cargo install"*) deny "'cargo install' drops binaries outside Nix (use rust-overlay / a dev-flake)." ;;
  *"gem install"*) deny "'gem install' is unrecorded global state." ;;
  *"go install"*) deny "'go install' drops binaries in ~/go/bin outside Nix." ;;
  *"sudo pip install"* | *"sudo pip3 install"*) deny "system-wide pip install mutates state outside Nix." ;;
  *"pip install --user"* | *"pip3 install --user"*) deny "'pip install --user' writes unrecorded state to ~/.local." ;;
  *"--break-system-packages"*) deny "'--break-system-packages' mutates the Nix-managed Python env." ;;
esac
exit 0
