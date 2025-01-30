# .bashrc

if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

PATH="$HOME/.cargo/bin:$PATH"

export PATH

if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

eval "$(starship init bash)"

bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

alias upgrade='sudo dnf upgrade'
alias untar='tar xzvf'
