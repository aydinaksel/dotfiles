#!/bin/bash

input=$(cat)

model_name=$(echo "$input" | jq -r '.model.display_name // "Unknown"' | sed 's/ ([^)]*context)//g')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // ""')
pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // 1000000')
context_used=$(echo "$input" | jq '[.context_window.current_usage.input_tokens, .context_window.current_usage.output_tokens, .context_window.current_usage.cache_creation_input_tokens, .context_window.current_usage.cache_read_input_tokens] | map(. // 0) | add')

fmt_tok() {
  local n=$1
  if [ "$n" -ge 1000000 ]; then
    printf '%.1fM' "$(echo "$n / 1000000" | bc -l)"
  elif [ "$n" -ge 1000 ]; then
    printf '%.1fk' "$(echo "$n / 1000" | bc -l)"
  else
    printf '%d' "$n"
  fi
}

token_str="$(fmt_tok $context_used)/$(fmt_tok $ctx_size)"
if [ "$pct" -ge 80 ]; then
  token_color="\033[31m"
elif [ "$pct" -ge 50 ]; then
  token_color="\033[33m"
else
  token_color="\033[32m"
fi

dir="$current_dir"
dir="${dir/#$HOME/\~}"
IFS='/' read -ra parts <<< "$dir"
n=${#parts[@]}
if [ "$n" -gt 3 ]; then
  dir="${parts[$((n-3))]}/${parts[$((n-2))]}/${parts[$((n-1))]}"
fi

git_info=""
if git -C "$current_dir" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$current_dir" branch --show-current 2>/dev/null || echo "detached")
  flags=""
  git -C "$current_dir" diff-index --quiet HEAD -- 2>/dev/null || flags+="!"
  [ -n "$(git -C "$current_dir" diff --cached --name-only 2>/dev/null)" ] && flags+="+"
  [ -n "$(git -C "$current_dir" ls-files --others --exclude-standard "$current_dir" 2>/dev/null | head -1)" ] && flags+="?"
  git_info="\033[1;35m⎇ ${branch}\033[0m"
  [ -n "$flags" ] && git_info+=" \033[33m${flags}\033[0m"
fi

sep="\033[2m | \033[0m"
out="${token_color}${token_str}\033[0m"
out+="${sep}\033[1;36m${dir}\033[0m"
[ -n "$git_info" ] && out+="${sep}${git_info}"
out+="${sep}\033[36m${model_name}\033[0m"

printf '%b' "$out"
