{ pkgs, config, ... }:
let
  obsidianHeadless = pkgs.callPackage ./package.nix { };
  vaultPath = "${config.home.homeDirectory}/Mind";
in
{
  home.packages = [ obsidianHeadless ];

  systemd.user.services.obsidian-sync = {
    Unit = {
      Description = "Obsidian headless continuous Sync";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      ExecStart = "${obsidianHeadless}/bin/ob sync --continuous";
      WorkingDirectory = vaultPath;
      Restart = "on-failure";
      RestartSec = 30;
    };

    Install.WantedBy = [ "default.target" ];
  };
}
