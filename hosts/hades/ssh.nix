{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      apollo = {
        hostname = "157.180.27.246";
        user = "aydin";
        identityFile = "~/.ssh/apollo.pub";
        identitiesOnly = true;
      };
      helios = {
        hostname = "5.78.186.219";
        user = "aydin";
        identityFile = "~/.ssh/helios.pub";
        identitiesOnly = true;
      };
      dionysus = {
        hostname = "178.156.169.27";
        user = "aydin";
        identityFile = "~/.ssh/dionysus.pub";
        identitiesOnly = true;
      };
      hestia = {
        hostname = "5.78.76.204";
        user = "aydin";
        identityFile = "~/.ssh/hestia.pub";
        identitiesOnly = true;
      };
      atlas = {
        hostname = "46.62.204.137";
        user = "aydin";
        identityFile = "~/.ssh/atlas.pub";
        identitiesOnly = true;
      };
      pan = {
        hostname = "5.161.195.52";
        user = "aydin";
        identityFile = "~/.ssh/pan.pub";
        identitiesOnly = true;
      };
      "github.com" = {
        identityFile = "~/.ssh/github.pub";
        addKeysToAgent = "yes";
      };
      freepbx = {
        hostname = "100.95.186.96";
        port = 22;
        user = "root";
        identityFile = "~/.ssh/id_ed25519_vultr_2025-09-09";
        identitiesOnly = true;
        setEnv.TERM = "xterm-256color";
      };
      dc2 = {
        hostname = "100.64.0.27";
        port = 22;
        user = "fbradmin";
        identityFile = "~/.ssh/id_ed25519_dc2";
        identitiesOnly = true;
        setEnv.TERM = "xterm-256color";
      };
      headscale = {
        hostname = "vpn.chichek.co.uk";
        port = 22;
        user = "root";
        identityFile = "~/.ssh/id_ed25519_chichek_infrastructure";
        identitiesOnly = true;
        setEnv.TERM = "xterm-256color";
      };
      zeus = {
        hostname = "zeus.darter-bebop.ts.net";
        port = 22;
        user = "aydin";
        identityFile = "~/.ssh/id_ed25519_zeus_2025-07-13";
        identitiesOnly = true;
        setEnv.TERM = "xterm-256color";
      };
      zeus-local = {
        hostname = "10.0.12.15";
        port = 22;
        user = "aydin";
        identityFile = "~/.ssh/id_ed25519_zeus_2025-07-13";
        identitiesOnly = true;
        setEnv.TERM = "xterm-256color";
      };
      remarkable = {
        hostname = "10.11.99.1";
        port = 22;
        user = "root";
        forwardX11 = false;
        forwardAgent = false;
        setEnv.TERM = "xterm-256color";
      };
      sapserver = {
        hostname = "100.106.223.11";
        port = 22;
        user = "hikmetfbr";
        identityFile = "~/.ssh/id_ed25519_sapserver_2026-03-12";
        identitiesOnly = true;
      };
    };
  };
}
