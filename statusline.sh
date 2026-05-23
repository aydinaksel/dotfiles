#!/bin/bash

eval "$(jq -r '
  @sh "pct=\(.context_window.used_percentage // 0)",
  @sh "used=\([.context_window.current_usage | .input_tokens, .output_tokens, .cache_creation_input_tokens, .cache_read_input_tokens] | map(. // 0) | add)",
  @sh "total=\(.context_window.context_window_size // 1000000)",
  @sh "model=\(.model.display_name // "Unknown" | gsub(" \\([^)]*context\\)"; ""))",
  @sh "effort=\(.effort.level // "")",
  @sh "five_hour=\(.rate_limits.five_hour.used_percentage // "")",
  @sh "seven_day=\(.rate_limits.seven_day.used_percentage // "")"
')"

fmt() {
  if [ "$1" -ge 1000000 ]; then printf '%d.%dM' $(($1/1000000)) $((($1%1000000)/100000))
  elif [ "$1" -ge 1000 ]; then printf '%d.%dk' $(($1/1000)) $((($1%1000)/100))
  else printf '%d' "$1"; fi
}

color() { printf '\033[%sm%s\033[0m' "$1" "$2"; }
sep='\033[2m | \033[0m'

if [ "$pct" -ge 80 ]; then tc=31; elif [ "$pct" -ge 50 ]; then tc=33; else tc=32; fi

label="$model"
[ -n "$effort" ] && label="$model on $(echo "${effort:0:1}" | tr '[:lower:]' '[:upper:]')${effort:1}"

out="$(color $tc "$(fmt $used)/$(fmt $total)")${sep}$(color 36 "$label")"

remaining() {
  local r=$((100 - $1))
  if [ "$r" -le 20 ]; then color 31 "${r}%"
  elif [ "$r" -le 50 ]; then color 33 "${r}%"
  else color 32 "${r}%"; fi
}

if [ -n "$five_hour" ] || [ -n "$seven_day" ]; then
  limits=""
  [ -n "$five_hour" ] && limits="5h: $(remaining "$five_hour")"
  [ -n "$seven_day" ] && { [ -n "$limits" ] && limits+=" "; limits+="7d: $(remaining "$seven_day")"; }
  out+="${sep}${limits}"
fi

printf '%b' "$out"
