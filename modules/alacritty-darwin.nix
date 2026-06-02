{ config, ... }:
{
  programs.alacritty = {
    theme = "catppuccin_macchiato";
    settings = {
      env.XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      terminal.shell.program = "/etc/profiles/per-user/aydinaksel/bin/nu";
      keyboard.bindings = [
        { key = "V"; mods = "Super"; action = "Paste"; }
        { key = "C"; mods = "Super"; action = "Copy"; }
        { key = "Plus"; mods = "Super"; action = "IncreaseFontSize"; }
        { key = "Minus"; mods = "Super"; action = "DecreaseFontSize"; }
        { key = "Key0"; mods = "Super"; action = "ResetFontSize"; }
        { key = "N"; mods = "Super"; action = "CreateNewWindow"; }
      ];
    };
  };
}
