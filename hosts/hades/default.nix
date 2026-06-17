{ pkgs, ... }:
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
    $env.SSH_AUTH_SOCK = $"($env.HOME)/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock"
    $env.GIT_SSH_COMMAND = "ssh"
  '';

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    XDG_DATA_DIRS = "$HOME/.nix-profile/share:\${XDG_DATA_DIRS:-/usr/local/share:/usr/share}";
  };

  fonts.fontconfig.enable = true;

  xdg.desktopEntries.mgba = {
    name = "mGBA";
    genericName = "Game Boy Advance Emulator";
    exec = "mgba-qt %f";
    icon = "${pkgs.mgba}/share/icons/hicolor/256x256/apps/io.mgba.mGBA.png";
    categories = [ "Game" "Emulator" ];
    mimeType = [ "application/x-gameboy-advance-rom" ];
  };

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
