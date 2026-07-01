{
  pkgs,
  lib,
  ...
}:

let
  runners = import ./runners.nix;

  runnerSecrets = builtins.listToAttrs (
    map (runner: {
      name = "github-runner-${runner.name}";
      value = {
        uuid = runner.secretUuid;
        owner = "github-runner";
        group = "github-runner";
      };
    }) runners
  );

  secrets = runnerSecrets // {
    "github-runner-ssh-key" = {
      uuid = "7bdc670f-00e8-4f16-a181-b47a00fb2d2c";
      owner = "github-runner";
      group = "github-runner";
    };
    "tailscale-oauth-client-secret" = {
      uuid = "a7ea5f37-e75a-4cfd-9e93-b47a00d72a1b";
      owner = "root";
      group = "root";
    };
  };

  accessTokenPath = "/var/lib/bws/access-token";

  fetchScript = pkgs.writeShellApplication {
    name = "bws-fetch-secrets";
    runtimeInputs = [
      pkgs.bws
      pkgs.jq
    ];
    text = ''
      BWS_ACCESS_TOKEN=$(cat ${accessTokenPath})
      export BWS_ACCESS_TOKEN

      mkdir -p /run/secrets
      chmod 0751 /run/secrets

      ${builtins.concatStringsSep "\n" (
        lib.mapAttrsToList (
          name: secret:
          let
            outputFlag = if secret.outputFormat or "" == "env" then "--output env" else "--output json";
            extractValue = if secret.outputFormat or "" == "env" then "" else " | jq -j '.value'";
          in
          ''
            bws secret get ${secret.uuid} ${outputFlag}${extractValue} > /run/secrets/${name}
            chown ${secret.owner}:${secret.group} /run/secrets/${name}
            chmod 0400 /run/secrets/${name}
          ''
        ) secrets
      )}
    '';
  };
in
{
  systemd.services.bws-secrets = {
    description = "Fetch secrets from Bitwarden Secrets Manager";
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${fetchScript}/bin/bws-fetch-secrets";
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/bws 0700 root root -"
  ];
}
