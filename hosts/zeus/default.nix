{ config, lib, pkgs, ... }:

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
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = [ "aydin" ];
  };

  nixpkgs.config.allowUnfreePredicate =
    package: builtins.elem (lib.getName package) [ "claude-code" "bws" ];

  users.users = {
    root.hashedPassword = "!";
    aydin = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      shell = pkgs.nushell;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILjiVN9Wh8FP+c1nHYSrQ0jztfymnEomxwxNVoW7/Iqy zeus key for hades"
      ];
    };
  };

  environment.shells = [ pkgs.nushell ];

  security.sudo.wheelNeedsPassword = false;

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
