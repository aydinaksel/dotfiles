if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if [ -f "$HOME/.profile" ]; then
    . "$HOME/.profile"
fi

bind "set show-all-if-ambiguous on"
bind "TAB:menu-complete"

alias upgrade="sudo dnf upgrade"
alias untar="tar xvf"
alias bye="shutdown now"
alias addreqs='xclip -selection clipboard -o | tr " " "\n" | sort -u >> requirements.txt'
alias copy='xclip -selection clipboard'
alias paste='xclip -selection clipboard -o'

csvpeek() {
  local file=$1
  local cols=${2:-3}  # default to 3 columns if not specified
  python3 -c "import csv, sys; [print(','.join(row[:${cols}])) for row in csv.reader(sys.stdin)]" < "$file" | bat -l csv
}

[ -f "$SF_AC_BASH_SETUP_PATH" ] && source "$SF_AC_BASH_SETUP_PATH"

. "$HOME/.local/share/../bin/env"
