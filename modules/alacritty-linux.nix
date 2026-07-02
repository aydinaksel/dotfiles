{ pkgs, ... }:
{
  programs.alacritty = {
    package = null;
    settings = {
      general.import = [
        "${pkgs.alacritty-theme}/share/alacritty-theme/catppuccin_macchiato.toml"
      ];
      font.size = 13.0;
      keyboard.bindings = [
        { key = "V"; mods = "Control|Shift"; action = "Paste"; }
        { key = "C"; mods = "Control|Shift"; action = "Copy"; }
        { key = "Plus"; mods = "Control"; action = "IncreaseFontSize"; }
        { key = "Minus"; mods = "Control"; action = "DecreaseFontSize"; }
        { key = "Key0"; mods = "Control"; action = "ResetFontSize"; }
        { key = "T"; mods = "Control|Shift"; action = "CreateNewWindow"; }
      ];
    };
  };
}
