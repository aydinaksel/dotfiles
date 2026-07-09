{ pkgs, ... }:
{
  imports = [
    ../../modules/claude-code.nix
    ../../modules/git.nix
    ../../modules/shell-tools.nix
    ../../modules/nushell.nix
    ../../modules/alacritty.nix
    ../../modules/alacritty-darwin.nix
    ../../modules/zellij.nix
  ];

  home.username = "aydinaksel";
  home.homeDirectory = "/Users/aydinaksel";
  home.stateVersion = "25.11";

  xdg.enable = true;

  programs.home-manager.enable = true;

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

  programs.nushell.extraEnv = ''
    $env.SSH_AUTH_SOCK = $"($env.HOME)/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    $env.GIT_SSH_COMMAND = "ssh"

    $env.HOMEBREW_AUTO_UPDATE_SECS = "86400"
    $env.HOMEBREW_NO_ENV_HINTS = "1"
  '';

  home.packages = with pkgs; [
    bat
    git
    jq
    lua-language-server
    (import ../../modules/neovim.nix { inherit pkgs; })
    nil
    nixfmt
    ripgrep
    ruff
    snowflake-cli
    tailscale
    tree-sitter
  ];
}
