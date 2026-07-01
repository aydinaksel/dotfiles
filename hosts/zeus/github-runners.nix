{ pkgs, ... }:

let
  runners = import ./runners.nix;

  runnerService = runner: {
    enable = true;
    url = runner.url;
    tokenFile = "/run/secrets/github-runner-${runner.name}";
    replace = true;
    extraLabels = [ "nixos" "zeus" ] ++ (runner.extraLabels or [ ]);
    extraPackages = with pkgs; [
      git
      gh
      nix
      bash
      coreutils
      gnutar
      gzip
    ];
  };
in
{
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
