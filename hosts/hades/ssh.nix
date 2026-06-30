{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      apollo = {
        HostName = "157.180.27.246";
        User = "aydin";
        IdentityFile = "~/.ssh/apollo.pub";
        IdentitiesOnly = true;
      };
      helios = {
        HostName = "5.78.186.219";
        User = "aydin";
        IdentityFile = "~/.ssh/helios.pub";
        IdentitiesOnly = true;
      };
      dionysus = {
        HostName = "178.156.169.27";
        User = "aydin";
        IdentityFile = "~/.ssh/dionysus.pub";
        IdentitiesOnly = true;
      };
      hestia = {
        HostName = "5.78.76.204";
        User = "aydin";
        IdentityFile = "~/.ssh/hestia.pub";
        IdentitiesOnly = true;
      };
      atlas = {
        HostName = "46.62.204.137";
        User = "aydin";
        IdentityFile = "~/.ssh/atlas.pub";
        IdentitiesOnly = true;
      };
      pan = {
        HostName = "5.161.195.52";
        User = "aydin";
        IdentityFile = "~/.ssh/pan.pub";
        IdentitiesOnly = true;
      };
      "github.com" = {
        IdentityFile = "~/.ssh/github.pub";
        AddKeysToAgent = true;
      };
      freepbx = {
        HostName = "100.95.186.96";
        Port = 22;
        User = "root";
        IdentityFile = "~/.ssh/id_ed25519_vultr_2025-09-09";
        IdentitiesOnly = true;
        SetEnv.TERM = "xterm-256color";
      };
      dc2 = {
        HostName = "100.64.0.27";
        Port = 22;
        User = "fbradmin";
        IdentityFile = "~/.ssh/id_ed25519_dc2";
        IdentitiesOnly = true;
        SetEnv.TERM = "xterm-256color";
      };
      headscale = {
        HostName = "vpn.chichek.co.uk";
        Port = 22;
        User = "root";
        IdentityFile = "~/.ssh/id_ed25519_chichek_infrastructure";
        IdentitiesOnly = true;
        SetEnv.TERM = "xterm-256color";
      };
      zeus = {
        HostName = "zeus.darter-bebop.ts.net";
        Port = 22;
        User = "aydin";
        IdentityFile = "~/.ssh/id_ed25519_zeus_2025-07-13";
        IdentitiesOnly = true;
        SetEnv.TERM = "xterm-256color";
      };
      zeus-local = {
        HostName = "10.0.12.15";
        Port = 22;
        User = "aydin";
        IdentityFile = "~/.ssh/id_ed25519_zeus_2025-07-13";
        IdentitiesOnly = true;
        SetEnv.TERM = "xterm-256color";
      };
      remarkable = {
        HostName = "10.11.99.1";
        Port = 22;
        User = "root";
        ForwardX11 = false;
        ForwardAgent = false;
        SetEnv.TERM = "xterm-256color";
      };
      sapserver = {
        HostName = "100.106.223.11";
        Port = 22;
        User = "hikmetfbr";
        IdentityFile = "~/.ssh/id_ed25519_sapserver_2026-03-12";
        IdentitiesOnly = true;
      };
    };
  };
}
