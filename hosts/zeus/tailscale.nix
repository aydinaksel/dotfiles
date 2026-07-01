{ pkgs, ... }:

let
  readinessTimeoutSeconds = 30;

  tailscale = "${pkgs.tailscale}/bin/tailscale";
  authKeyFile = "/run/secrets/tailscale-oauth-client-secret";
in
{
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  systemd.services.tailscale-zeus-connect = {
    description = "Authenticate the zeus host Tailscale node";
    after = [ "tailscaled.service" "bws-secrets.service" ];
    requires = [ "tailscaled.service" "bws-secrets.service" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.coreutils pkgs.jq ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      for _ in $(seq 1 ${toString readinessTimeoutSeconds}); do
        backend_state=$(${tailscale} status --json 2>/dev/null \
          | jq -r '.BackendState' 2>/dev/null || true)
        [ -n "$backend_state" ] && break
        sleep 1
      done

      if [ "$backend_state" != "Running" ]; then
        ${tailscale} up \
          --authkey="$(cat ${authKeyFile})?ephemeral=false&preauthorized=true" \
          --advertise-tags=tag:zeus \
          --hostname=zeus
      fi
    '';
  };
}
