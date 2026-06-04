{ pkgs, ... }:
let
  tilingShell = pkgs.gnomeExtensions.tiling-shell;
  roundedCorners = pkgs.gnomeExtensions.rounded-window-corners-reborn;

  portraitLayoutId = "87113171";
  landscapeLayoutId = "50505050";

  autoLayoutScript = pkgs.writeShellScript "tiling-shell-auto-layout" ''
    set -uo pipefail

    PORTRAIT_LAYOUT="${portraitLayoutId}"
    LANDSCAPE_LAYOUT="${landscapeLayoutId}"
    DCONF_KEY="/org/gnome/shell/extensions/tilingshell/selected-layouts"

    update_layouts() {
      local transforms
      transforms=$(gdbus call --session \
        --dest org.gnome.Mutter.DisplayConfig \
        --object-path /org/gnome/Mutter/DisplayConfig \
        --method org.gnome.Mutter.DisplayConfig.GetCurrentState \
        | python3 -c "
    import sys, re
    data = sys.stdin.read()
    section = data[data.rfind('], [('):]
    monitors = re.findall(r'\(\d+,\s*\d+,\s*[\d.]+,\s*(?:uint32\s+)?(\d+),\s*(?:true|false)', section)
    print(' '.join(monitors))
    ")

      if [ -z "$transforms" ]; then
        echo "No monitors found" >&2
        return 1
      fi

      local num_workspaces
      num_workspaces=$(dconf read /org/gnome/desktop/wm/preferences/num-workspaces 2>/dev/null || echo "")
      local dynamic
      dynamic=$(dconf read /org/gnome/mutter/dynamic-workspaces 2>/dev/null || echo "")

      if [ "$dynamic" = "true" ] || [ -z "$num_workspaces" ]; then
        num_workspaces=10
      fi

      local monitor_layouts=""
      for transform in $transforms; do
        if [ "$transform" = "1" ] || [ "$transform" = "3" ]; then
          monitor_layouts="$monitor_layouts '$PORTRAIT_LAYOUT',"
        else
          monitor_layouts="$monitor_layouts '$LANDSCAPE_LAYOUT',"
        fi
      done
      monitor_layouts="''${monitor_layouts%,}"

      local workspace_entry="[$monitor_layouts]"
      local all_entries=""
      for ((i = 0; i < num_workspaces; i++)); do
        all_entries="$all_entries $workspace_entry,"
      done
      all_entries="''${all_entries%,}"

      dconf write "$DCONF_KEY" "[$all_entries]"
      echo "Updated: transforms=$transforms layouts=[$all_entries]"
    }

    update_layouts

    gdbus monitor --session \
      --dest org.gnome.Mutter.DisplayConfig \
      --object-path /org/gnome/Mutter/DisplayConfig |
    while read -r line; do
      if [[ "$line" == *"MonitorsChanged"* ]]; then
        sleep 1
        update_layouts || true
      fi
    done
  '';
in
{
  home.file.".local/share/gnome-shell/extensions/tilingshell@ferrarodomenico.com".source =
    "${tilingShell}/share/gnome-shell/extensions/tilingshell@ferrarodomenico.com";

  home.file.".local/share/gnome-shell/extensions/${roundedCorners.extensionUuid}".source =
    "${roundedCorners}/share/gnome-shell/extensions/${roundedCorners.extensionUuid}";

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "background-logo@fedorahosted.org"
        "appindicatorsupport@rgcjonas.gmail.com"
        "tilingshell@ferrarodomenico.com"
        roundedCorners.extensionUuid
      ];
    };

    "org/gnome/desktop/wm/keybindings" = {
      activate-window-menu = [ "<Super>space" ];
      maximize = [];
      switch-input-source = [];
      switch-input-source-backward = [];
      unmaximize = [];
    };

    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [];
      toggle-tiled-right = [];
    };

    "org/gnome/shell/extensions/tilingshell" = {
      edge-tiling-mode = "default";
      enable-smart-window-border-radius = true;
      enable-snap-assist = false;
      enable-window-border = true;
      cycle-layouts = [];
      span-window-all-tiles = [ "<Super>f" ];
      move-window-up = [ "<Super>Up" ];
      move-window-down = [ "<Super>Down" ];
      move-window-left = [ "<Super>Left" ];
      move-window-right = [ "<Super>Right" ];
      focus-window-down = [];
      focus-window-next = [ "<Super>c" ];
      focus-window-prev = [];
      focus-window-up = [];
      last-version-name-installed = "17.3";
      layouts-json = builtins.toJSON [
        {
          id = portraitLayoutId;
          tiles = [
            {
              x = 0;
              y = 0;
              width = 1;
              height = 0.5;
              groups = [ 1 ];
            }
            {
              x = 0;
              y = 0.5;
              width = 1;
              height = 0.5;
              groups = [ 1 ];
            }
          ];
        }
        {
          id = landscapeLayoutId;
          tiles = [
            {
              x = 0;
              y = 0;
              width = 0.5;
              height = 1;
              groups = [ 1 ];
            }
            {
              x = 0.5;
              y = 0;
              width = 0.5;
              height = 1;
              groups = [ 1 ];
            }
          ];
        }
      ];
      overridden-settings = ''{"org.gnome.mutter.keybindings":{"toggle-tiled-right":"['<Super>Right']","toggle-tiled-left":"['<Super>Left']"},"org.gnome.desktop.wm.keybindings":{"maximize":"['<Super>Up']","unmaximize":"['<Super>Down', '<Alt>F5']"},"org.gnome.mutter":{"edge-tiling":"true"}}'';
      show-indicator = false;
      tiling-system-activation-key = [ "2" ];
      window-border-width = 3;
      window-use-custom-border-color = false;
    };
  };

  systemd.user.services.tiling-shell-auto-layout = {
    Unit = {
      Description = "Auto-set Tiling Shell layouts based on monitor orientation";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${autoLayoutScript}";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
