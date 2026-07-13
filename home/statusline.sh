#!/usr/bin/env bash
# Shared by personal (~/.claude) and work (~/.config/claude-work). Prepends a WORK
# badge when run under the work config dir so the accounts are distinguishable.
input=$(cat)
MODEL=$(echo "$input" | jq -r '.model.display_name')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')

if   [ "$PCT" -ge 90 ]; then COLOR='\033[31m'
elif [ "$PCT" -ge 70 ]; then COLOR='\033[33m'
else COLOR='\033[32m'; fi
RESET='\033[0m'

FILLED=$((PCT / 10)); EMPTY=$((10 - FILLED))
printf -v FILL "%${FILLED}s"; printf -v PAD "%${EMPTY}s"
BAR="${FILL// /▓}${PAD// /░}"
COST_FMT=$(printf '$%.3f' "$COST")

TAG=""
case "$CLAUDE_CONFIG_DIR" in
  *claude-work*) TAG='\033[1;97;45m WORK \033[0m ' ;;  # bold white on magenta
esac

echo -e "${TAG}${COLOR}${BAR}${RESET} ${PCT}% | ${COST_FMT} | [${MODEL}]"
