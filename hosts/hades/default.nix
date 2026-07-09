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
    ../../modules/ssh.nix
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
  # session. Point it at Bitwarden so those apps (e.g. Beekeeper Studio) use
  # the same keys as the shell.
  #
  # On Fedora, gcr-ssh-agent.socket runs an ExecStartPost that calls
  # `systemctl --user set-environment SSH_AUTH_SOCK=%t/gcr/ssh`, clobbering the
  # environment.d value at every login. Masking the socket stops that, letting
  # 10-ssh-auth-sock.conf win. gcr's secrets and pkcs11 components are separate
  # units and keep running.
  xdg.configFile = {
    "environment.d/10-ssh-auth-sock.conf".text = ''
      SSH_AUTH_SOCK=${bitwardenSshAgentSocket}
    '';
    "systemd/user/gcr-ssh-agent.socket".source =
      config.lib.file.mkOutOfStoreSymlink "/dev/null";
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
