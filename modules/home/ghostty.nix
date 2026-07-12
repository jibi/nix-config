{ ... }:

{
  programs.ghostty = {
    enable = true;

    settings = {
      background = "#000000";
      foreground = "#eaeaea";
      bold-is-bright = true;

      palette = [
        "0=#000000"
        "1=#d70000"
        "2=#00d75f"
        "3=#ff8700"
        "4=#005fd7"
        "5=#ff00d7"
        "6=#00ffaf"
        "7=#dddddd"
        "8=#444444"
        "9=#ff0000"
        "10=#00d787"
        "11=#ffaf00"
        "12=#0087d7"
        "13=#ff00ff"
        "14=#74f4ff"
        "15=#ffffff"
      ];

      cursor-color = "#002fd7";
      cursor-text = "#000000";
      cursor-style-blink = false;
      shell-integration-features = "no-cursor";

      font-family = "DejaVuSansM Nerd Font Mono";
      font-style-bold = false;
      font-size = 14;
      adjust-cell-width = -4;

      background-opacity = 0.6;

      resize-overlay = "never";
      window-inherit-working-directory = false;
      scrollbar = "never";

      scrollback-limit = 100000;

      keybind = [ "shift+enter=csi:13;2u" ];
    };
  };
}
