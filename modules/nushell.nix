{
  programs.nushell = {
    enable = true;
    settings = {
      show_banner = false;
      edit_mode = "emacs";
      history = {
        max_size = 100000;
        sync_on_enter = true;
        file_format = "plaintext";
        isolation = false;
      };
      completions = {
        case_sensitive = false;
        quick = true;
        partial = true;
        algorithm = "fuzzy";
      };
      cursor_shape.emacs = "line";
    };
    extraEnv = ''
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
              $"/etc/profiles/per-user/($env.USER)/bin"
              "/run/current-system/sw/bin"
              "/nix/var/nix/profiles/default/bin"
              "/opt/homebrew/bin"
              "/opt/homebrew/sbin"
              "/usr/local/bin"
          ]
          | uniq
      )

      $env.DIRENV_LOG_FORMAT = ""
    '';
    extraConfig = ''
      $env.config.hooks.pre_prompt = ($env.config.hooks.pre_prompt | default [] | append { ||
          if (which direnv | is-empty) { return }
          direnv export json | from json -s | default {} | load-env
      })
    '';
  };

  xdg.configFile = {
    "nushell/autoload/claude-prune-projects.nu".source = ../nu/autoload/claude-prune-projects.nu;
    "nushell/autoload/claude-reset.nu".source = ../nu/autoload/claude-reset.nu;
    "nushell/autoload/just.nu".source = ../nu/autoload/just.nu;
  };
}
