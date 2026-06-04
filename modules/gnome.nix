{ pkgs, ... }:
let
  tilingShell = pkgs.gnomeExtensions.tiling-shell;
  roundedCorners = pkgs.gnomeExtensions.rounded-window-corners-reborn;
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
      maximize = [];
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
      cycle-layouts = [ "<Super>f" ];
      move-window-up = [ "<Super>Up" ];
      move-window-down = [ "<Super>Down" ];
      move-window-left = [];
      move-window-right = [];
      focus-window-down = [];
      focus-window-next = [ "<Super>Right" ];
      focus-window-prev = [ "<Super>Left" ];
      focus-window-up = [];
      last-version-name-installed = "17.3";
      layouts-json = ''[{"id":"87113171","tiles":[{"x":0,"y":0,"width":1,"height":0.5,"groups":[2]},{"x":0,"y":0.5,"width":1,"height":0.5,"groups":[2]}]},{"id":"full","tiles":[{"x":0,"y":0,"width":1,"height":1,"groups":[1]}]}]'';
      overridden-settings = ''{"org.gnome.mutter.keybindings":{"toggle-tiled-right":"['<Super>Right']","toggle-tiled-left":"['<Super>Left']"},"org.gnome.desktop.wm.keybindings":{"maximize":"['<Super>Up']","unmaximize":"['<Super>Down', '<Alt>F5']"},"org.gnome.mutter":{"edge-tiling":"true"}}'';
      selected-layouts = [ [ "87113171" "87113171" ] [ "87113171" "87113171" ] ];
      show-indicator = false;
      tiling-system-activation-key = [ "2" ];
      window-border-width = 3;
      window-use-custom-border-color = false;
    };
  };
}
