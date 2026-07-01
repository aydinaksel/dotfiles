{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./secrets.nix
    ./tailscale.nix
    ./github-runners.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "zeus";
  networking.useNetworkd = true;
  systemd.network.networks."10-wired" = {
    matchConfig.Name = "en*";
    networkConfig.DHCP = "yes";
  };

  time.timeZone = "Europe/London";

  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = [ "aydin" ];
  };

  nixpkgs.config.allowUnfreePredicate =
    package:
    builtins.elem (lib.getName package) [
      "claude-code"
      "bws"
    ];

  users.users = {
    root.hashedPassword = "!";
    aydin = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      shell = pkgs.nushell;
      hashedPassword = "$6$5ZEf7lev8WfyVJLs$Y/mE439JjgK6hpsKIhTcJ5aCOBqZYjIvhsbHPmHSloRskzuJs//xehd9urN2EoJYoSwSjm5rKeg9Z3/MAf8Gw1";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINsxjFjrSymUk/ppxj6SpngzUV563B8cK5s1coIuPGjs"
      ];
    };
  };

  environment.shells = [ pkgs.nushell ];

  security.sudo.wheelNeedsPassword = false;

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    gh
    htop
  ];

  system.stateVersion = "26.05";
}
