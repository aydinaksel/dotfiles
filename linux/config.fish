set -x XDG_DATA_HOME $HOME/.local/share
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_STATE_HOME $HOME/.local/state
set -x XDG_CACHE_HOME $HOME/.cache

set -x LOCAL_BINARIES $HOME/.local/bin

set -x EDITOR $LOCAL_BINARIES/nvim

set -x AWS_CONFIG_FILE $XDG_CONFIG_HOME/aws/config
set -x AWS_SHARED_CREDENTIALS_FILE $XDG_CONFIG_HOME/aws/credentials

set -x CARGO_HOME $XDG_DATA_HOME/cargo
set -x RUSTUP_HOME $XDG_DATA_HOME/rustup
set -x GOPATH $XDG_DATA_HOME/go
set -x NPMPATH $HOME/.local/lib/npm-global

set -x DOCKER_CONFIG $XDG_CONFIG_HOME/docker
set -x GNUPGHOME $XDG_DATA_HOME/gnupg

set -x NPM_CONFIG_INIT_MODULE $XDG_CONFIG_HOME/npm/config/npm-init.js
set -x NPM_CONFIG_CACHE $XDG_CACHE_HOME/npm
set -x NPM_CONFIG_TMP $XDG_RUNTIME_DIR/npm

set -x PYTHON_HISTORY $XDG_STATE_HOME/python/history

set -x _JAVA_OPTIONS "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"

set -x SF_DISABLE_TELEMETRY true

set -g fish_greeting ""

fish_add_path $HOME/bin $HOME/.local/bin $CARGO_HOME/bin $GOPATH/bin $NPMPATH/bin

if test -f $HOME/.local/bin/env.fish
    source $HOME/.local/bin/env.fish
end

alias upgrade "sudo dnf upgrade"
alias untar "tar xvf"
alias bye "shutdown now"
alias copy "wl-copy"
alias paste "wl-paste"
alias nvimconfig "cd ~/.config/nvim"
alias addreqs "xclip -selection clipboard -o | tr ' ' '\n' | sort -u >> requirements.txt"

starship init fish | source
