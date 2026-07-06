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

  infraSecrets = runnerSecrets // {
    "github-runner-ssh-key" = {
      uuid = "7bdc670f-00e8-4f16-a181-b47a00fb2d2c";
      owner = "github-runner";
      group = "github-runner";
      trailingNewline = true;
    };
    "aydin-github-ssh-key" = {
      uuid = "c60aa092-c41a-499f-a6fc-b47a01689349";
      owner = "aydin";
      group = "users";
      trailingNewline = true;
    };
    "tailscale-oauth-client-secret" = {
      uuid = "a7ea5f37-e75a-4cfd-9e93-b47a00d72a1b";
      owner = "root";
      group = "root";
    };
  };

  personalAutomationSecrets = {
    "gmail-app-password" = {
      uuid = "b8d60c1c-b664-4cbc-be3c-b47f010b8979";
      owner = "aydin";
      group = "users";
    };
    "r2-credentials" = {
      uuid = "ee7e37dc-c920-470e-8425-b47f010e6850";
      owner = "aydin";
      group = "users";
    };
  };

  mkFetchScript =
    { name, accessTokenPath, secrets }:
    pkgs.writeShellApplication {
      name = "bws-fetch-${name}";
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
            secretName: secret:
            let
              outputFlag = if secret.outputFormat or "" == "env" then "--output env" else "--output json";
              extractValue =
                if secret.outputFormat or "" == "env" then
                  ""
                else if secret.trailingNewline or false then
                  " | jq -r '.value'"
                else
                  " | jq -j '.value'";
            in
            ''
              bws secret get ${secret.uuid} ${outputFlag}${extractValue} > /run/secrets/${secretName}
              chown ${secret.owner}:${secret.group} /run/secrets/${secretName}
              chmod 0400 /run/secrets/${secretName}
            ''
          ) secrets
        )}
      '';
    };

  mkFetchService =
    { name, accessTokenPath, secrets }:
    {
      description = "Fetch ${name} secrets from Bitwarden Secrets Manager";
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${mkFetchScript { inherit name accessTokenPath secrets; }}/bin/bws-fetch-${name}";
      };
    };

  sources = {
    bws-secrets = {
      accessTokenPath = "/var/lib/bws/access-token";
      secrets = infraSecrets;
    };
    bws-secrets-personal-automation = {
      accessTokenPath = "/var/lib/bws/personal-automation-access-token";
      secrets = personalAutomationSecrets;
    };
  };
in
{
  systemd.services = lib.mapAttrs (
    name: source: mkFetchService { inherit name; inherit (source) accessTokenPath secrets; }
  ) sources;

  systemd.tmpfiles.rules = [
    "d /var/lib/bws 0700 root root -"
  ];
}
