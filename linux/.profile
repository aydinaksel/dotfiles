export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

export EDITOR="/usr/bin/nvim"

export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"

export HISTFILE="$XDG_STATE_HOME/bash/history"

export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

export GNUPGHOME="$XDG_DATA_HOME/gnupg"

export NPM_CONFIG_INIT_MODULE="$XDG_CONFIG_HOME/npm/config/npm-init.js"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_TMP="$XDG_RUNTIME_DIR/npm"

export PYTHON_HISTORY="$XDG_STATE_HOME/python/history"

export GOPATH="$HOME/.local/share/go"
export NPMPATH="$HOME/.local/lib/npm-global"

export SF_DISABLE_TELEMETRY="true"

FIRST_PROMPT=1
PROMPT_COMMAND='
  if [ $FIRST_PROMPT -eq 0 ]; then
    printf "\n"
  fi
  FIRST_PROMPT=0
'
export PS1="\[\033[0;36m\][\u@\h \W]\$\[\033[0m\] "

export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.cargo/bin:$GOPATH/bin:$NPMPATH/bin:$PATH"

. "$HOME/.local/share/../bin/env"
