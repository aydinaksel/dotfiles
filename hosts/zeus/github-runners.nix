{ pkgs, ... }:

let
  runners = import ./runners.nix;

  runnerUser = "github-runner";
  runnerHome = "/var/lib/github-runner";
  deployKeyPath = "/run/secrets/github-runner-ssh-key";

  knownHosts = pkgs.writeText "github-runner-known-hosts" ''
    github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
  '';

  sshConfig = pkgs.writeText "github-runner-ssh-config" ''
    Host github.com
      HostKeyAlgorithms ssh-ed25519

    Host hestia
      HostName 5.78.76.204
      User aydin

    Host helios
      HostName 5.78.186.219
      User aydin

    Host *
      IdentityFile ${deployKeyPath}
      IdentitiesOnly yes
      StrictHostKeyChecking accept-new
  '';

  runnerService = runner: {
    enable = true;
    url = runner.url;
    tokenFile = "/run/secrets/github-runner-${runner.name}";
    replace = true;
    user = runnerUser;
    group = runnerUser;
    extraLabels = [ "nixos" "zeus" ] ++ (runner.extraLabels or [ ]);
    extraPackages = with pkgs; [
      git
      gh
      nix
      openssh
      bash
      coreutils
      gnutar
      gzip
    ];
  };
in
{
  users.users.${runnerUser} = {
    isSystemUser = true;
    group = runnerUser;
    home = runnerHome;
    createHome = true;
  };
  users.groups.${runnerUser} = { };

  systemd.tmpfiles.rules = [
    "d ${runnerHome}/.ssh 0700 ${runnerUser} ${runnerUser} -"
    "L+ ${runnerHome}/.ssh/id_ed25519 - - - - ${deployKeyPath}"
    "L+ ${runnerHome}/.ssh/known_hosts - - - - ${knownHosts}"
    "L+ ${runnerHome}/.ssh/config - - - - ${sshConfig}"
  ];

  services.github-runners = builtins.listToAttrs (map (runner: {
    name = runner.name;
    value = runnerService runner;
  }) runners);

  systemd.services = builtins.listToAttrs (map (runner: {
    name = "github-runner-${runner.name}";
    value = {
      after = [ "bws-secrets.service" ];
      requires = [ "bws-secrets.service" ];
    };
  }) runners);
}
