# Zeus

NixOS dev server. Its main job is hosting self-hosted GitHub Actions runners
for CI/CD, plus a Claude/zellij dev environment.

The system config lives here and is wired into the repo flake as
`nixosConfigurations.zeus`. Home Manager for `aydin` is integrated as a NixOS
module (`home.nix`), so a single `nixos-rebuild switch` applies both system and
user config.

## Layout

-   `default.nix` — system config: boot, user, hardened SSH, nix settings.
-   `hardware-configuration.nix` — generated hardware scan (do not hand-edit).
-   `home.nix` — Home Manager config for `aydin` (Claude, zellij, nushell, dev
    tooling).
-   `secrets.nix` — fetches secrets from Bitwarden Secrets Manager into
    `/run/secrets/` at boot (mirrors the Apollo pattern).
-   `tailscale.nix` — brings the node onto the tailnet using an OAuth secret.
-   `runners.nix` — the list of GitHub runners (name, URL, Bitwarden UUID).
-   `github-runners.nix` — turns that list into systemd runner services.

## First-time bootstrap (run once on the machine as root)

The repo intentionally contains no secrets. Two things must exist on disk
before the secret-dependent services can start:

1.  Bitwarden Secrets Manager access token, read by `secrets.nix`:

    ```sh
    install -d -m 0700 /var/lib/bws
    install -m 0400 /dev/stdin /var/lib/bws/access-token   # paste the machine access token, then Ctrl-D
    ```

2.  In Bitwarden Secrets Manager, create one secret per entry below and copy its
    UUID into the matching field:

    | Secret                            | Value                                                        | Field to fill                    |
    | --------------------------------- | ------------------------------------------------------------ | -------------------------------- |
    | `tailscale-oauth-client-secret`   | Tailscale OAuth client secret authorized for `tag:zeus`      | `secrets.nix`                    |
    | one GitHub token per runner scope | classic PAT with `admin:org` (orgs) or fine-grained repo PAT | `runners.nix` (`secretUuid`)     |

## Runners

Edit `runners.nix`: fill in each org URL, the personal repo URL, and the
Bitwarden `secretUuid` for its token. A runner registers to exactly one org OR
one repo, so each personal repo needs its own entry.

The `bws-secrets` service writes each token to
`/run/secrets/github-runner-<name>`; every `github-runner-<name>.service`
depends on it and picks the token up from there.

## Tailscale

`tag:zeus` must exist in the tailnet ACL and the OAuth client must be authorized
to issue keys for it. The node comes up with hostname `zeus`.

## Deploying

On the machine:

```sh
nixos-rebuild switch --flake ~/dotfiles#zeus
```

Or remotely from another host that can reach it over SSH/Tailscale:

```sh
nixos-rebuild switch --flake ~/dotfiles#zeus --target-host aydin@zeus --use-remote-sudo
```

## SSH

Password and root SSH login are disabled. Access is key-only as `aydin`; the
Zeus key (`~/.ssh/id_ed25519_zeus_2025-07-13` on hades) is authorized. Add more
keys under `users.users.aydin.openssh.authorizedKeys.keys` in `default.nix`.
