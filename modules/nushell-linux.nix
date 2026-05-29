{
  programs.nushell = {
    shellAliases = {
      upgrade = "sudo dnf upgrade";
      untar = "tar xvf";
      bye = "shutdown now";
      nvimconfig = "cd ~/.config/nvim";
      ll = "ls -la";
      la = "ls -a";
    };
    extraConfig = ''
      def copy [] {
        if ($env.WAYLAND_DISPLAY? | is-not-empty) {
          $in | wl-copy
        } else if ($env.DISPLAY? | is-not-empty) {
          $in | xclip -selection clipboard
        } else {
          let encoded = ($in | encode base64)
          print -n $"\e]52;c;($encoded)\a"
        }
      }

      def paste [] {
        if ($env.WAYLAND_DISPLAY? | is-not-empty) {
          wl-paste
        } else if ($env.DISPLAY? | is-not-empty) {
          xclip -selection clipboard -o
        } else {
          error make { msg: "paste not supported over OSC 52 (write-only)" }
        }
      }

      def tailscale-switch [] {
          let status = (tailscale status --json | from json)
          let current = $status.CurrentTailnet.Name
          if $current == "vpn.fbrmarble.com" {
              sudo tailscale switch Chichek
          } else {
              sudo tailscale switch vpn.fbrmarble.com
          }
          sleep 3sec
          sudo systemctl restart tailscaled
      }

      def bws-fbr [...arguments: string] {
          with-env { BWS_ACCESS_TOKEN: (open ~/.secrets/bws-token-fbr | str trim) } { bws ...$arguments }
      }

      def bws-chichek [...arguments: string] {
          with-env { BWS_ACCESS_TOKEN: (open ~/.secrets/bws-token-chichek | str trim) } { bws ...$arguments }
      }
    '';
  };

  xdg.configFile = {
    "nushell/autoload/claude-prune-projects.nu".source = ../linux/nu/autoload/claude-prune-projects.nu;
    "nushell/autoload/claude-reset.nu".source = ../linux/nu/autoload/claude-reset.nu;
  };
}
