# Nushell environment configuration.
# Loaded before config.nu on startup.

$env.XDG_DATA_HOME = $"($env.HOME)/.local/share"
$env.XDG_CONFIG_HOME = $"($env.HOME)/.config"
$env.XDG_STATE_HOME = $"($env.HOME)/.local/state"
$env.XDG_CACHE_HOME = $"($env.HOME)/.cache"

$env.EDITOR = "nvim"

$env.AWS_CONFIG_FILE = $"($env.XDG_CONFIG_HOME)/aws/config"
$env.AWS_SHARED_CREDENTIALS_FILE = $"($env.XDG_CONFIG_HOME)/aws/credentials"

$env.CARGO_HOME = $"($env.XDG_DATA_HOME)/cargo"
$env.RUSTUP_HOME = $"($env.XDG_DATA_HOME)/rustup"
$env.GOPATH = $"($env.XDG_DATA_HOME)/go"
$env.NPMPATH = $"($env.HOME)/.local/lib/npm-global"

$env.DOCKER_CONFIG = $"($env.XDG_CONFIG_HOME)/docker"
$env.GNUPGHOME = $"($env.XDG_DATA_HOME)/gnupg"

$env.NPM_CONFIG_INIT_MODULE = $"($env.XDG_CONFIG_HOME)/npm/config/npm-init.js"
$env.NPM_CONFIG_CACHE = $"($env.XDG_CACHE_HOME)/npm"

$env.CLAUDE_CODE_QUIET_STARTUP = "1"

$env.PYTHON_HISTORY = $"($env.XDG_STATE_HOME)/python/history"

$env._JAVA_OPTIONS = $"-Djava.util.prefs.userRoot=($env.XDG_CONFIG_HOME)/java"

$env.SF_DISABLE_TELEMETRY = "true"

$env.NTN_INSTALL_DIR = $"($env.HOME)/.local/bin"

$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend [
        $"($env.HOME)/bin"
        $"($env.HOME)/.local/bin"
        $"($env.CARGO_HOME)/bin"
        $"($env.GOPATH)/bin"
        $"($env.NPMPATH)/bin"
        $"($env.HOME)/.nix-profile/bin"
        "/nix/var/nix/profiles/default/bin"
        "/opt/homebrew/bin"
        "/opt/homebrew/sbin"
        "/usr/local/bin"
    ]
    | uniq
)

# Generate the starship prompt loader. Sourced from config.nu.
let starship_cache = $"($env.XDG_CACHE_HOME)/starship/init.nu"
mkdir ($starship_cache | path dirname)
^starship init nu | save --force $starship_cache

# Point at the persistent user-level ssh-agent (~/.config/systemd/user/ssh-agent.service)
# so Zellij panes don't end up with a stale SSH_AUTH_SOCK after reconnecting via SSH.
$env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR? | default $'/run/user/(id -u | str trim)')/ssh-agent.socket"
$env.GIT_SSH_COMMAND = "ssh"

$env.DIRENV_LOG_FORMAT = ""
