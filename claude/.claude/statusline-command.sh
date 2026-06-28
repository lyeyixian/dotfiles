#!/bin/sh
input=$(cat)
dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# ANSI color codes (printf-compatible)
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

# Build status parts
status=""

# current directory — cyan
if [ -n "$dir" ]; then
  status="${CYAN}${dir}${RESET}"
fi

# model name — green
if [ -n "$model" ]; then
  status="${status}  ${GREEN}[${model}]${RESET}"
fi

# context: tokens used + used percentage — yellow
if [ -n "$total_input" ] && [ -n "$used_pct" ]; then
  # Format token count as e.g. 174k or 1.2m
  ctx_k=$(awk -v n="$total_input" 'BEGIN {
    if (n >= 1000000) { printf "%.1fm", n/1000000 }
    else if (n >= 1000) { printf "%.0fk", n/1000 }
    else { printf "%d", n }
  }')
  printf_used=$(printf "%.0f" "$used_pct")
  status="${status}  ${YELLOW}ctx:${ctx_k} (${printf_used}%)${RESET}"
fi

printf '%b' "$status"
