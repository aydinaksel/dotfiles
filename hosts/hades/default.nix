{ config, pkgs, ... }:
let
  bitwardenSshAgentSocket =
    "${config.home.homeDirectory}/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock";
in
{
  imports = [
    ../../modules/claude-code.nix
    ../../modules/git.nix
    ../../modules/shell-tools.nix
    ../../modules/nushell.nix
    ../../modules/nushell-linux.nix
    ../../modules/zellij.nix
    ../../modules/alacritty.nix
    ../../modules/alacritty-linux.nix
    ../../modules/gnome.nix
  ];

  home.username = "aydin";
  home.homeDirectory = "/home/aydin";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  programs.nushell.extraEnv = ''
    $env.SSH_AUTH_SOCK = "${bitwardenSshAgentSocket}"
    $env.GIT_SSH_COMMAND = "ssh"
  '';

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };

  # GUI apps launched from GNOME inherit SSH_AUTH_SOCK from the systemd user
  # session. Take it back from gnome-keyring's ssh agent so those apps use the
  # same Bitwarden keys as the shell. Only the ssh component is disabled; the
  # secrets and pkcs11 components keep running.
  xdg.configFile = {
    "environment.d/10-ssh-auth-sock.conf".text = ''
      SSH_AUTH_SOCK=${bitwardenSshAgentSocket}
    '';
    "autostart/gnome-keyring-ssh.desktop".text = ''
      [Desktop Entry]
      Hidden=true
    '';
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    ffsend
    mdbook
    (import ../../modules/neovim.nix { inherit pkgs; })
    nil
    nixfmt
    ripgrep
    snowflake-cli
    tree-sitter
    hcloud
    hujsonfmt
    wuzz
    gopls
    (pkgs.writeShellApplication {
      name = "mgba-qt";
      runtimeInputs = [ pkgs.nixgl.nixGLIntel pkgs.mgba ];
      text = ''nixGLIntel mgba-qt "$@"'';
    })
  ];
}
