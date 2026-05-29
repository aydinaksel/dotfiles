{ pkgs, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.enable = false;

  system.stateVersion = 6;

  system.primaryUser = "aydinaksel";
  users.users.aydinaksel.home = "/Users/aydinaksel";

  security.pam.services.sudo_local.enable = false;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    casks = [
      "1password"
      "bitwarden"
      "firefox@developer-edition"
      "google-chrome"
      "pritunl"
      "slack"
    ];
  };

  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
      mru-spaces = false;
      minimize-to-application = true;
    };
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv";
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      AppleInterfaceStyle = "Dark";
    };
    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
    };
    CustomUserPreferences = {
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
    };
  };
}
