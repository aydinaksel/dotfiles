{ pkgs, ... }:
{
  imports = [
    ../../modules/claude-code.nix
    ../../modules/git.nix
    ../../modules/shell-tools.nix
    ../../modules/nushell.nix
    ../../modules/nushell-linux.nix
    ../../modules/zellij.nix
  ];

  home.username = "aydin";
  home.homeDirectory = "/home/aydin";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/fold-l.jxl";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/fold-d.jxl";
      primary-color = "#26a269";
      secondary-color = "#000000";
    };
  };

  programs.nushell.extraEnv = ''
    $env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR? | default $'/run/user/(id -u | str trim)')/ssh-agent.socket"
    $env.GIT_SSH_COMMAND = "ssh"
  '';

  home.packages = with pkgs; [
    bat
    curl
    dust
    jq
    just
    mdbook
    (import ../../modules/neovim.nix { inherit pkgs; })
    nil
    nixfmt
    qrrs
    ripgrep
    rustlings
    tree-sitter
    xh
  ];
}
