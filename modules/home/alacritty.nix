{ ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        draw_bold_text_with_bright_colors = true;
        primary = {
          background = "0x000000";
          foreground = "0xeaeaea";
        };
        normal = {
          black = "0x000000";
          red = "0xd70000";
          green = "0x00d75f";
          yellow = "0xff8700";
          blue = "0x005fd7";
          magenta = "0xff00d7";
          cyan = "0x00ffaf";
          white = "0xdddddd";
        };
        bright = {
          black = "0x444444";
          red = "0xff0000";
          green = "0x00d787";
          yellow = "0xffaf00";
          blue = "0x0087d7";
          magenta = "0xff00ff";
          cyan = "0x74f4ff";
          white = "0xffffff";
        };
        cursor = {
          cursor = "0x002fd7";
          text = "0x000000";
        };
      };
      font = {
        size = 14;
        normal.family = "DejaVuSansM Nerd Font Mono";
        bold = {
          family = "DejaVuSansM Nerd Font Mono";
          style = "Regular";
        };
        offset = {
          x = -3;
          y = 0;
        };
      };
      window.opacity = 0.6;
      scrolling = {
        history = 100000;
        multiplier = 10;
      };
      keyboard.bindings = [
        {
          key = "Return";
          mods = "Shift";
          chars = "\\u001B\\r";
        }
      ];
    };
  };
}
