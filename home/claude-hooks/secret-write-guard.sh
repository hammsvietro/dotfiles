# Claude Code hook: block writing plaintext into secret locations.
# PreToolUse(Write|Edit) for the dotfiles repo.
# Runs under writeShellApplication: bash, `set -euo pipefail`, jq on PATH.

repo="$HOME/dotfiles"
input=$(cat)
cwd=$(jq -r '.cwd // empty' <<<"$input")
dir="${CLAUDE_PROJECT_DIR:-${cwd:-$PWD}}"

case "$dir" in
  "$repo" | "$repo"/*) ;;
  *) exit 0 ;;
esac

file=$(jq -r '.tool_input.file_path // empty' <<<"$input")
[ -n "$file" ] || exit 0

deny() {
  echo "Secret-write guard: $1" >&2
  exit 2
}

case "$file" in
  "$HOME/.config/sops/age/keys.txt")
    deny "refusing to write the age private key. Leaking or losing it decrypts (or destroys) every secret." ;;
  "$HOME/.local/share/blackwall"/* | "$HOME/blackwall"/*)
    deny "that is the decrypted blackwall vault. Edit it, then run 'blackwall-lock' — never write plaintext that could be committed." ;;
  "$repo"/secrets/*.yaml | "$repo"/secrets/*.json | "$repo"/secrets/*.env)
    deny "edit encrypted secrets with 'sops $file', not by writing plaintext — a direct write drops cleartext into the repo." ;;
esac
exit 0
