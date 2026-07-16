{ pkgs, ... }:
{
  systemd.user.services.megacmd-server = {
    Unit = {
      Description = "MEGA CMD server daemon";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      ExecStart = "${pkgs.megacmd}/bin/mega-cmd-server";
      Restart = "on-failure";
      RestartSec = 30;
    };

    Install.WantedBy = [ "default.target" ];
  };
}
