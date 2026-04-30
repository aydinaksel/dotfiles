export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home"
export EDITOR="/opt/homebrew/bin/nvim"
export PATH="$CARGO_HOME/bin:$HOME/.local/bin:$PATH"

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

SF_AC_ZSH_SETUP_PATH="$HOME/Library/Caches/sf/autocomplete/zsh_setup"
test -f "$SF_AC_ZSH_SETUP_PATH" && source "$SF_AC_ZSH_SETUP_PATH"

alias fix-pritunl='sudo launchctl load /Library/LaunchDaemons/com.pritunl.service.plist'
alias togglesleep='if [[ $(pmset -g | grep "SleepDisabled" | awk '\''{print $2}'\'') -eq 0 ]]; then sudo pmset -a disablesleep 1 && echo "Sleep disabled"; else sudo pmset -a disablesleep 0 && echo "Sleep enabled"; fi'

eval "$(starship init zsh)"
