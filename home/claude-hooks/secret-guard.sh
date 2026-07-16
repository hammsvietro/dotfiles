# Claude Code hook: secret-leak gate for the dotfiles repo.
# PreToolUse(Bash) on git commit/push scans staged changes; Stop scans the
# uncommitted working tree ("check for leaked keys before finishing").
# Runs under writeShellApplication: bash, `set -euo pipefail`, and
# gitleaks/git/jq/coreutils already on PATH.

repo="$HOME/dotfiles"
input=$(cat)

event=$(jq -r '.hook_event_name // empty' <<<"$input")
cwd=$(jq -r '.cwd // empty' <<<"$input")
dir="${CLAUDE_PROJECT_DIR:-${cwd:-$PWD}}"

case "$dir" in
  "$repo" | "$repo"/*) ;;
  *) exit 0 ;;
esac

[ -d "$repo/.git" ] || exit 0
cfg="$repo/.gitleaks.toml"

if [ "$event" = "Stop" ]; then
  active=$(jq -r '.stop_hook_active // false' <<<"$input")
  [ "$active" = "true" ] && exit 0

  findings=""
  while IFS= read -r -d '' path; do
    [ -f "$repo/$path" ] || continue
    if ! out=$(gitleaks dir "$repo/$path" --no-banner --no-color --redact -c "$cfg" 2>&1); then
      findings+="$out"$'\n'
    fi
  done < <( { git -C "$repo" diff --name-only -z HEAD; git -C "$repo" ls-files --others --exclude-standard -z; } )

  if [ -n "$findings" ]; then
    echo "gitleaks: an uncommitted change looks like it contains a secret. Remove it before finishing." >&2
    printf '%s' "$findings" | tail -n 40 >&2
    exit 2
  fi
  exit 0
fi

cmd=$(jq -r '.tool_input.command // empty' <<<"$input")
case "$cmd" in
  *"git commit"* | *"git push"*) ;;
  *) exit 0 ;;
esac

if ! out=$(gitleaks git --staged --no-banner --no-color --redact -c "$cfg" "$repo" 2>&1); then
  echo "gitleaks: staged changes look like they contain a secret -- commit blocked." >&2
  echo "If it is a genuine false positive, allowlist it in .gitleaks.toml." >&2
  printf '%s' "$out" | tail -n 40 >&2
  exit 2
fi
exit 0
