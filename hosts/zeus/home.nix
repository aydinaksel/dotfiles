{ pkgs, lib, config, ... }:
let
  inherit (lib.hm.gvariant)
    mkArray
    mkTuple
    mkVariant
    mkUint32
    mkDouble
    mkDictionaryEntry
    ;

  bitwardenSshAgentSocket = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";

  mkWorldClock =
    {
      name,
      station,
      cityLatitudeRadians,
      cityLongitudeRadians,
      stationLatitudeRadians,
      stationLongitudeRadians,
    }:
    mkArray "{sv}" [
      (mkDictionaryEntry [
        "location"
        (mkVariant (mkTuple [
          (mkUint32 2)
          (mkVariant (mkTuple [
            name
            station
            true
            (mkArray "(dd)" [ (mkTuple [ (mkDouble cityLatitudeRadians) (mkDouble cityLongitudeRadians) ]) ])
            (mkArray "(dd)" [ (mkTuple [ (mkDouble stationLatitudeRadians) (mkDouble stationLongitudeRadians) ]) ])
          ]))
        ]))
      ])
    ];

  # A detached GWeather location: a custom-named point at exact coordinates,
  # equivalent to adding a place via GNOME Weather's map picker. Forecasts come
  # from met.no queried by latitude/longitude, so they are accurate for the
  # point even when the nearest observation station has a different name.
  mkWeatherLocation =
    {
      name,
      latitudeRadians,
      longitudeRadians,
      stationLatitudeRadians,
      stationLongitudeRadians,
    }:
    mkVariant (mkTuple [
      (mkUint32 2)
      (mkVariant (mkTuple [
        name
        ""
        false
        (mkArray "(dd)" [ (mkTuple [ (mkDouble latitudeRadians) (mkDouble longitudeRadians) ]) ])
        (mkArray "(dd)" [ (mkTuple [ (mkDouble stationLatitudeRadians) (mkDouble stationLongitudeRadians) ]) ])
      ]))
    ]);

  yorkWeather = mkWeatherLocation {
    name = "York";
    latitudeRadians = 0.94177966437614036;
    longitudeRadians = -0.018976964956934343;
    stationLatitudeRadians = 0.94305956667650515;
    stationLongitudeRadians = -0.021816615649929118;
  };
in
{
  imports = [
    ../../modules/claude-code.nix
    ../../modules/git.nix
    ../../modules/shell-tools.nix
    ../../modules/nushell.nix
    ../../modules/nushell-linux.nix
    ../../modules/zellij.nix
    ../../modules/alacritty.nix
    ../../modules/alacritty-linux.nix
    ../../modules/obsidian-headless
    ../../modules/megacmd-server.nix
    ../../modules/ssh.nix
  ];

  programs.alacritty.package = lib.mkForce pkgs.alacritty;

  home.username = "aydin";
  home.homeDirectory = "/home/aydin";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      clock-format = "24h";
      clock-show-weekday = true;
      clock-show-date = true;
      clock-show-seconds = false;
    };
    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };
    "org/gnome/clocks" = {
      world-clocks = mkArray "a{sv}" [
        (mkWorldClock {
          name = "Istanbul";
          station = "LTBA";
          cityLatitudeRadians = 0.71500322271810779;
          cityLongitudeRadians = 0.50294571860079684;
          stationLatitudeRadians = 0.71590981654476371;
          stationLongitudeRadians = 0.505529765824837;
        })
        (mkWorldClock {
          name = "Sofia";
          station = "LBSF";
          cityLatitudeRadians = 0.74438292597558142;
          cityLongitudeRadians = 0.40811615094024323;
          stationLatitudeRadians = 0.74496469657514885;
          stationLongitudeRadians = 0.4069526097411087;
        })
        (mkWorldClock {
          name = "Houston";
          station = "KHOU";
          cityLatitudeRadians = 0.51727195705981943;
          cityLongitudeRadians = -1.6629933445314968;
          stationLatitudeRadians = 0.51946730200614799;
          stationLongitudeRadians = -1.6644030644216252;
        })
        (mkWorldClock {
          name = "Los Angeles";
          station = "KHHR";
          cityLatitudeRadians = 0.59207870611576607;
          cityLongitudeRadians = -2.0652820330855488;
          stationLatitudeRadians = 0.59432360095955872;
          stationLongitudeRadians = -2.063741622941031;
        })
      ];
    };
    "org/gnome/shell/weather" = {
      automatic-location = false;
      locations = mkArray "v" [ yorkWeather ];
    };
    "org/gnome/Weather" = {
      automatic-location = false;
      locations = mkArray "v" [ yorkWeather ];
    };
    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/fold-l.jxl";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/fold-d.jxl";
      primary-color = "#26a269";
      secondary-color = "#000000";
    };
  };

  programs.nushell.extraEnv = ''
    $env.SSH_AUTH_SOCK = "${bitwardenSshAgentSocket}"
    $env.GIT_SSH_COMMAND = "ssh"
  '';

  # GUI apps launched from GNOME inherit SSH_AUTH_SOCK from the systemd user
  # session. Take it back from gnome-keyring's ssh agent so those apps use the
  # same Bitwarden keys as the shell. Only the ssh component is disabled; the
  # secrets and pkcs11 components keep running.
  xdg.configFile = {
    "environment.d/10-ssh-auth-sock.conf".text = ''
      SSH_AUTH_SOCK=${bitwardenSshAgentSocket}
    '';
    "autostart/gnome-keyring-ssh.desktop".text = ''
      [Desktop Entry]
      Hidden=true
    '';
  };

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    bat
    bitwarden-desktop
    curl
    dust
    jq
    just
    mdbook
    (import ../../modules/neovim.nix { inherit pkgs; })
    nil
    nixfmt
    qrrs
    ripgrep
    rustlings
    tree-sitter
    xh
  ];
}
