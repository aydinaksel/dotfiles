{ pkgs, inputs, ... }:

let
  uberTickets = inputs.uber-tickets.packages.${pkgs.system}.default;
  vaultDirectory = "/home/aydin/Mind";
in
{
  systemd.services.uber-tickets = {
    description = "Fetch Uber train tickets into Obsidian and the Cloudflare R2 calendar feed";
    after = [
      "network-online.target"
      "bws-secrets-personal-automation.service"
    ];
    wants = [ "network-online.target" ];
    requires = [ "bws-secrets-personal-automation.service" ];

    serviceConfig = {
      Type = "oneshot";
      User = "aydin";
      Group = "users";
      ExecStart = "${uberTickets}/bin/uber-tickets";

      LoadCredential = [
        "gmail-app-password:/run/secrets/gmail-app-password"
        "r2-credentials:/run/secrets/r2-credentials"
      ];

      Environment = [
        "GMAIL_USERNAME=aaydinaksel@gmail.com"
        "VAULT_DIRECTORY=${vaultDirectory}"
        "SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt"
        "RUST_LOG=info"
      ];

      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = "tmpfs";
      BindPaths = [ vaultDirectory ];
      ReadWritePaths = [ vaultDirectory ];
      PrivateTmp = true;
      PrivateDevices = true;
      ProtectProc = "invisible";
      ProtectClock = true;
      ProtectHostname = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RemoveIPC = true;
      RestrictAddressFamilies = [
        "AF_UNIX"
        "AF_INET"
        "AF_INET6"
        "AF_NETLINK"
      ];
      SystemCallArchitectures = "native";
      SystemCallFilter = [ "@system-service" ];
      CapabilityBoundingSet = "";
      AmbientCapabilities = "";
      UMask = "0077";
    };
  };

  systemd.timers.uber-tickets = {
    description = "Periodic Uber ticket fetch";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*:0/15";
      Persistent = true;
    };
  };
}
