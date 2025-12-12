if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if [ -f "$HOME/.profile" ]; then
    . "$HOME/.profile"
fi

bind "set show-all-if-ambiguous on"
bind "TAB:menu-complete"

alias upgrade="sudo dnf upgrade"
alias untar="tar xzvf"
alias bye="shutdown now"
alias addreqs='xclip -selection clipboard -o | tr " " "\n" | sort -u >> requirements.txt'

. "$HOME/.local/share/../bin/env"
