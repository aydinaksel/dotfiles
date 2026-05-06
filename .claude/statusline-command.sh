#!/bin/bash

input=$(cat)

model_name=$(echo "$input" | jq -r '.model.display_name // "Unknown"' | sed 's/ ([^)]*context)//g')
thinking_enabled=$(echo "$input" | jq -r '.thinking.enabled // false')
effort_level=$(echo "$input" | jq -r '.effort.level // empty')
five_hour_used=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_day_used=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
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
model_display="${model_name}"
if [ -n "$effort_level" ]; then
  capitalized="$(echo "${effort_level:0:1}" | tr '[:lower:]' '[:upper:]')${effort_level:1}"
  model_display="${model_name} on ${capitalized}"
fi
out+="${sep}\033[36m${model_display}\033[0m"

rate_limit_color() {
  local used=$1
  local remaining=$(printf '%.0f' "$(echo "100 - $used" | bc -l)")
  if [ "$remaining" -le 20 ]; then
    printf '\033[31m%s%%\033[0m' "$remaining"
  elif [ "$remaining" -le 50 ]; then
    printf '\033[33m%s%%\033[0m' "$remaining"
  else
    printf '\033[32m%s%%\033[0m' "$remaining"
  fi
}

if [ -n "$five_hour_used" ] || [ -n "$seven_day_used" ]; then
  limits=""
  [ -n "$five_hour_used" ] && limits+="5h: $(rate_limit_color "$five_hour_used")"
  if [ -n "$seven_day_used" ]; then
    [ -n "$limits" ] && limits+=" "
    limits+="7d: $(rate_limit_color "$seven_day_used")"
  fi
  out+="${sep}${limits}"
fi

printf '%b' "$out"
