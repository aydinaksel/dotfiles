{
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "alacritty";
      window = {
        padding = {
          x = 16;
          y = 16;
        };
        dynamic_padding = true;
        decorations = "Full";
        opacity = 1.0;
        startup_mode = "Windowed";
      };
      scrolling = {
        history = 10000;
        multiplier = 3;
      };
      font = {
        size = 13.0;
        normal = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Italic";
        };
        bold_italic = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Bold Italic";
        };
      };
      cursor = {
        style = {
          shape = "Block";
          blinking = "On";
        };
        unfocused_hollow = true;
      };
      selection.save_to_clipboard = true;
      mouse.hide_when_typing = true;
    };
  };
}
