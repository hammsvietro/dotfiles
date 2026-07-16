# Claude Code hook: format edited Nix files with nixfmt (RFC style).
# PostToolUse(Write|Edit) for the dotfiles repo. Best-effort; never blocks.
# Runs under writeShellApplication: bash, `set -euo pipefail`, jq/nixfmt on PATH.

repo="$HOME/dotfiles"
input=$(cat)
cwd=$(jq -r '.cwd // empty' <<<"$input")
dir="${CLAUDE_PROJECT_DIR:-${cwd:-$PWD}}"

case "$dir" in
  "$repo" | "$repo"/*) ;;
  *) exit 0 ;;
esac

file=$(jq -r '.tool_input.file_path // empty' <<<"$input")
case "$file" in
  *.nix)
    if [ -f "$file" ]; then
      nixfmt "$file" >/dev/null 2>&1 || true
    fi
    ;;
esac
exit 0
