{
  description = "Aydin's dotfiles";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      unfreePackages = [ "claude-code" ];
      allowUnfree =
        package: builtins.elem (package.pname or (builtins.parseDrvName package.name).name) unfreePackages;
      linuxPkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfreePredicate = allowUnfree;
      };
      darwinPkgs = import nixpkgs {
        system = "aarch64-darwin";
        config.allowUnfreePredicate = allowUnfree;
      };
    in
    {
      homeConfigurations."aydin@zeus" = home-manager.lib.homeManagerConfiguration {
        pkgs = linuxPkgs;
        modules = [
          (import ./claude-code.nix)
          {
            home.username = "aydin";
            home.homeDirectory = "/home/aydin";
            home.stateVersion = "25.11";

            programs.home-manager.enable = true;
            programs.direnv = {
              enable = true;
              nix-direnv.enable = true;
            };
            programs.git = {
              enable = true;
              settings = {
                user.name = "Aydin Aksel";
                user.email = "154738769+aydinaksel@users.noreply.github.com";
                core.editor = "nvim";
                init.defaultBranch = "main";
                color.ui = "auto";
                push.autoSetupRemote = true;
              };
            };
            programs.starship = {
              enable = true;
              settings = import ./starship.nix;
            };
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
              shellAliases = {
                upgrade = "sudo dnf upgrade";
                untar = "tar xvf";
                bye = "shutdown now";
                nvimconfig = "cd ~/.config/nvim";
                ll = "ls -la";
                la = "ls -a";
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
                        "/nix/var/nix/profiles/default/bin"
                        "/opt/homebrew/bin"
                        "/opt/homebrew/sbin"
                        "/usr/local/bin"
                    ]
                    | uniq
                )

                $env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR? | default $'/run/user/(id -u | str trim)')/ssh-agent.socket"
                $env.GIT_SSH_COMMAND = "ssh"

                $env.DIRENV_LOG_FORMAT = ""
              '';
              extraConfig = ''
                def copy [] {
                  if ($env.WAYLAND_DISPLAY? | is-not-empty) {
                    $in | wl-copy
                  } else if ($env.DISPLAY? | is-not-empty) {
                    $in | xclip -selection clipboard
                  } else {
                    let encoded = ($in | encode base64)
                    print -n $"\e]52;c;($encoded)\a"
                  }
                }

                def paste [] {
                  if ($env.WAYLAND_DISPLAY? | is-not-empty) {
                    wl-paste
                  } else if ($env.DISPLAY? | is-not-empty) {
                    xclip -selection clipboard -o
                  } else {
                    error make { msg: "paste not supported over OSC 52 (write-only)" }
                  }
                }

                def tailscale-switch [] {
                    let status = (tailscale status --json | from json)
                    let current = $status.CurrentTailnet.Name
                    if $current == "vpn.fbrmarble.com" {
                        sudo tailscale switch Chichek
                    } else {
                        sudo tailscale switch vpn.fbrmarble.com
                    }
                    sleep 3sec
                    sudo systemctl restart tailscaled
                }

                def bws-fbr [...arguments: string] {
                    with-env { BWS_ACCESS_TOKEN: (open ~/.secrets/bws-token-fbr | str trim) } { bws ...$arguments }
                }

                def bws-chichek [...arguments: string] {
                    with-env { BWS_ACCESS_TOKEN: (open ~/.secrets/bws-token-chichek | str trim) } { bws ...$arguments }
                }

                $env.config.hooks.pre_prompt = ($env.config.hooks.pre_prompt | default [] | append { ||
                    if (which direnv | is-empty) { return }
                    direnv export json | from json -s | default {} | load-env
                })
              '';
            };
            programs.gitui = {
              enable = true;
              theme = ''
                (
                    selected_tab: Some("Reset"),
                    command_fg: Some("#cad3f5"),
                    selection_bg: Some("#5b6078"),
                    selection_fg: Some("#cad3f5"),
                    cmdbar_bg: Some("#1e2030"),
                    cmdbar_extra_lines_bg: Some("#1e2030"),
                    disabled_fg: Some("#8087a2"),
                    diff_line_add: Some("#a6da95"),
                    diff_line_delete: Some("#ed8796"),
                    diff_file_added: Some("#a6da95"),
                    diff_file_removed: Some("#ee99a0"),
                    diff_file_moved: Some("#c6a0f6"),
                    diff_file_modified: Some("#f5a97f"),
                    commit_hash: Some("#b7bdf8"),
                    commit_time: Some("#b8c0e0"),
                    commit_author: Some("#7dc4e4"),
                    danger_fg: Some("#ed8796"),
                    push_gauge_bg: Some("#8aadf4"),
                    push_gauge_fg: Some("#24273a"),
                    tag_fg: Some("#f4dbd6"),
                    branch_fg: Some("#8bd5ca")
                )
              '';
            };
            programs.gh = {
              enable = true;
              settings = {
                git_protocol = "https";
                prompt = "enabled";
                aliases = {
                  co = "pr checkout";
                };
              };
            };
            programs.zellij = {
              enable = true;
              settings = {
                theme = "catppuccin-macchiato";
                default_mode = "normal";
                default_shell = "nu";
              };
            };

            xdg.configFile = {
              "nushell/autoload/claude-prune-projects.nu".source = ./linux/nu/autoload/claude-prune-projects.nu;
              "nushell/autoload/claude-reset.nu".source = ./linux/nu/autoload/claude-reset.nu;
            };

            home.packages = with linuxPkgs; [
              bat
              curl
              dust
              jq
              just
              mdbook
              (import ./neovim.nix { pkgs = linuxPkgs; })
              nil
              nixfmt
              qrrs
              ripgrep
              rustlings
              tree-sitter
              xh
            ];
          }
        ];
      };

      homeConfigurations."aydin@hades" = home-manager.lib.homeManagerConfiguration {
        pkgs = linuxPkgs;
        modules = [
          (import ./claude-code.nix)
          {
            home.username = "aydin";
            home.homeDirectory = "/home/aydin";
            home.stateVersion = "25.11";

            programs.home-manager.enable = true;
            programs.direnv = {
              enable = true;
              nix-direnv.enable = true;
            };
            programs.git = {
              enable = true;
              settings = {
                user.name = "Aydin Aksel";
                user.email = "154738769+aydinaksel@users.noreply.github.com";
                core.editor = "nvim";
                init.defaultBranch = "main";
                color.ui = "auto";
                push.autoSetupRemote = true;
              };
            };
            programs.starship = {
              enable = true;
              settings = import ./starship.nix;
            };
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
              shellAliases = {
                upgrade = "sudo dnf upgrade";
                untar = "tar xvf";
                bye = "shutdown now";
                nvimconfig = "cd ~/.config/nvim";
                ll = "ls -la";
                la = "ls -a";
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
                        "/nix/var/nix/profiles/default/bin"
                        "/opt/homebrew/bin"
                        "/opt/homebrew/sbin"
                        "/usr/local/bin"
                    ]
                    | uniq
                )

                $env.SSH_AUTH_SOCK = $"($env.HOME)/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock"
                $env.GIT_SSH_COMMAND = "ssh"

                $env.DIRENV_LOG_FORMAT = ""
              '';
              extraConfig = ''
                def copy [] {
                  if ($env.WAYLAND_DISPLAY? | is-not-empty) {
                    $in | wl-copy
                  } else if ($env.DISPLAY? | is-not-empty) {
                    $in | xclip -selection clipboard
                  } else {
                    let encoded = ($in | encode base64)
                    print -n $"\e]52;c;($encoded)\a"
                  }
                }

                def paste [] {
                  if ($env.WAYLAND_DISPLAY? | is-not-empty) {
                    wl-paste
                  } else if ($env.DISPLAY? | is-not-empty) {
                    xclip -selection clipboard -o
                  } else {
                    error make { msg: "paste not supported over OSC 52 (write-only)" }
                  }
                }

                def tailscale-switch [] {
                    let status = (tailscale status --json | from json)
                    let current = $status.CurrentTailnet.Name
                    if $current == "vpn.fbrmarble.com" {
                        sudo tailscale switch Chichek
                    } else {
                        sudo tailscale switch vpn.fbrmarble.com
                    }
                    sleep 3sec
                    sudo systemctl restart tailscaled
                }

                def bws-fbr [...arguments: string] {
                    with-env { BWS_ACCESS_TOKEN: (open ~/.secrets/bws-token-fbr | str trim) } { bws ...$arguments }
                }

                def bws-chichek [...arguments: string] {
                    with-env { BWS_ACCESS_TOKEN: (open ~/.secrets/bws-token-chichek | str trim) } { bws ...$arguments }
                }

                $env.config.hooks.pre_prompt = ($env.config.hooks.pre_prompt | default [] | append { ||
                    if (which direnv | is-empty) { return }
                    direnv export json | from json -s | default {} | load-env
                })
              '';
            };
            programs.gitui = {
              enable = true;
              theme = ''
                (
                    selected_tab: Some("Reset"),
                    command_fg: Some("#cad3f5"),
                    selection_bg: Some("#5b6078"),
                    selection_fg: Some("#cad3f5"),
                    cmdbar_bg: Some("#1e2030"),
                    cmdbar_extra_lines_bg: Some("#1e2030"),
                    disabled_fg: Some("#8087a2"),
                    diff_line_add: Some("#a6da95"),
                    diff_line_delete: Some("#ed8796"),
                    diff_file_added: Some("#a6da95"),
                    diff_file_removed: Some("#ee99a0"),
                    diff_file_moved: Some("#c6a0f6"),
                    diff_file_modified: Some("#f5a97f"),
                    commit_hash: Some("#b7bdf8"),
                    commit_time: Some("#b8c0e0"),
                    commit_author: Some("#7dc4e4"),
                    danger_fg: Some("#ed8796"),
                    push_gauge_bg: Some("#8aadf4"),
                    push_gauge_fg: Some("#24273a"),
                    tag_fg: Some("#f4dbd6"),
                    branch_fg: Some("#8bd5ca")
                )
              '';
            };
            programs.gh = {
              enable = true;
              settings = {
                git_protocol = "https";
                prompt = "enabled";
                aliases = {
                  co = "pr checkout";
                };
              };
            };
            programs.alacritty = {
              enable = true;
              package = null;
              settings = {
                general.import = [
                  "${linuxPkgs.alacritty-theme}/share/alacritty-theme/catppuccin_macchiato.toml"
                ];
                env.TERM = "alacritty";
                window = {
                  padding = {
                    x = 8;
                    y = 8;
                  };
                  dynamic_padding = true;
                  decorations = "full";
                  opacity = 1.0;
                };
                scrolling = {
                  history = 10000;
                  multiplier = 3;
                };
                font = {
                  size = 11.0;
                  normal = {
                    family = "JetBrainsMono Nerd Font Mono";
                    style = "Regular";
                  };
                  bold = {
                    family = "JetBrainsMono Nerd Font Mono";
                    style = "Bold";
                  };
                  italic = {
                    family = "JetBrainsMono Nerd Font Mono";
                    style = "Italic";
                  };
                  bold_italic = {
                    family = "JetBrainsMono Nerd Font Mono";
                    style = "Bold Italic";
                  };
                };
                cursor = {
                  style = {
                    shape = "Block";
                    blinking = "On";
                  };
                  unfocused_hollow = true;
                };
                selection.save_to_clipboard = true;
                mouse.hide_when_typing = true;
                keyboard.bindings = [
                  {
                    key = "V";
                    mods = "Control|Shift";
                    action = "Paste";
                  }
                  {
                    key = "C";
                    mods = "Control|Shift";
                    action = "Copy";
                  }
                  {
                    key = "Plus";
                    mods = "Control";
                    action = "IncreaseFontSize";
                  }
                  {
                    key = "Minus";
                    mods = "Control";
                    action = "DecreaseFontSize";
                  }
                  {
                    key = "Key0";
                    mods = "Control";
                    action = "ResetFontSize";
                  }
                  {
                    key = "T";
                    mods = "Control|Shift";
                    action = "CreateNewWindow";
                  }
                ];
              };
            };
            programs.zellij = {
              enable = true;
              settings = {
                theme = "catppuccin-macchiato";
                default_mode = "normal";
                default_shell = "nu";
              };
            };

            xdg.configFile = {
              "nushell/autoload/claude-prune-projects.nu".source = ./linux/nu/autoload/claude-prune-projects.nu;
              "nushell/autoload/claude-reset.nu".source = ./linux/nu/autoload/claude-reset.nu;
            };

            home.packages = with linuxPkgs; [
              ffsend
              mdbook
              nil
              nixfmt
              ripgrep
              snowflake-cli
              tree-sitter
              hcloud
              hujsonfmt
              wuzz
              gopls
            ];
          }
        ];
      };

      homeConfigurations."aydinaksel" = home-manager.lib.homeManagerConfiguration {
        pkgs = darwinPkgs;
        modules = [
          (import ./claude-code.nix)
          {
            home.username = "aydinaksel";
            home.homeDirectory = "/Users/aydinaksel";
            home.stateVersion = "25.11";

            programs.home-manager.enable = true;
            programs.direnv = {
              enable = true;
              nix-direnv.enable = true;
            };
            programs.git = {
              enable = true;
              settings = {
                user.name = "Aydin Aksel";
                user.email = "154738769+aydinaksel@users.noreply.github.com";
                core.editor = "nvim";
                init.defaultBranch = "main";
                color.ui = "auto";
                push.autoSetupRemote = true;
              };
            };
            programs.ssh = {
              enable = true;
              enableDefaultConfig = false;
              settings = {
                "github.com" = {
                  HostName = "github.com";
                  User = "git";
                  IdentityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
                };
                "zeus" = {
                  HostName = "zeus.darter-bebop.ts.net";
                  User = "aydin";
                };
              };
            };
            programs.starship = {
              enable = true;
              settings = import ./starship.nix;
            };
            programs.gitui = {
              enable = true;
              theme = ''
                (
                    selected_tab: Some("Reset"),
                    command_fg: Some("#cad3f5"),
                    selection_bg: Some("#5b6078"),
                    selection_fg: Some("#cad3f5"),
                    cmdbar_bg: Some("#1e2030"),
                    cmdbar_extra_lines_bg: Some("#1e2030"),
                    disabled_fg: Some("#8087a2"),
                    diff_line_add: Some("#a6da95"),
                    diff_line_delete: Some("#ed8796"),
                    diff_file_added: Some("#a6da95"),
                    diff_file_removed: Some("#ee99a0"),
                    diff_file_moved: Some("#c6a0f6"),
                    diff_file_modified: Some("#f5a97f"),
                    commit_hash: Some("#b7bdf8"),
                    commit_time: Some("#b8c0e0"),
                    commit_author: Some("#7dc4e4"),
                    danger_fg: Some("#ed8796"),
                    push_gauge_bg: Some("#8aadf4"),
                    push_gauge_fg: Some("#24273a"),
                    tag_fg: Some("#f4dbd6"),
                    branch_fg: Some("#8bd5ca")
                )
              '';
            };
            programs.gh = {
              enable = true;
              settings = {
                git_protocol = "https";
                prompt = "enabled";
                aliases = {
                  co = "pr checkout";
                };
              };
            };
            programs.alacritty = {
              enable = true;
              theme = "catppuccin_macchiato";
              settings = {
                env.TERM = "alacritty";
                window = {
                  padding = {
                    x = 8;
                    y = 8;
                  };
                  dynamic_padding = true;
                  decorations = "full";
                  opacity = 1.0;
                };
                scrolling = {
                  history = 10000;
                  multiplier = 3;
                };
                font = {
                  size = 11.0;
                  normal = {
                    family = "JetBrainsMono Nerd Font Mono";
                    style = "Regular";
                  };
                  bold = {
                    family = "JetBrainsMono Nerd Font Mono";
                    style = "Bold";
                  };
                  italic = {
                    family = "JetBrainsMono Nerd Font Mono";
                    style = "Italic";
                  };
                  bold_italic = {
                    family = "JetBrainsMono Nerd Font Mono";
                    style = "Bold Italic";
                  };
                };
                cursor = {
                  style = {
                    shape = "Block";
                    blinking = "On";
                  };
                  unfocused_hollow = true;
                };
                selection.save_to_clipboard = true;
                mouse.hide_when_typing = true;
                keyboard.bindings = [
                  {
                    key = "V";
                    mods = "Super";
                    action = "Paste";
                  }
                  {
                    key = "C";
                    mods = "Super";
                    action = "Copy";
                  }
                  {
                    key = "Plus";
                    mods = "Super";
                    action = "IncreaseFontSize";
                  }
                  {
                    key = "Minus";
                    mods = "Super";
                    action = "DecreaseFontSize";
                  }
                  {
                    key = "Key0";
                    mods = "Super";
                    action = "ResetFontSize";
                  }
                  {
                    key = "N";
                    mods = "Super";
                    action = "CreateNewWindow";
                  }
                ];
              };
            };

            home.packages = with darwinPkgs; [
              git
              ruff
              (import ./neovim.nix { pkgs = darwinPkgs; })
              nil
              jq
              nixfmt
              ripgrep
              tree-sitter
              bat
            ];
          }
        ];
      };
    };
}
