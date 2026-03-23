{
  layer = "top";
  position = "top";
  exclusive = true;
  passthrough = false;
  gtk-layer-shell = true;
  ipc = false;
  height = 30;
  margin = "0";

  modules-left = [
    "dwl/tags"
    "wlr/taskbar"
  ];
  modules-center = [
    "dwl/window"
  ];
  modules-right = [
    "battery"
    "pulseaudio"
    "tray"
    "clock"
  ];

  "dwl/tags" = {
    num-tags = 9;
    hide-vacant = true;
    expand = false;
    disable-click = true;
    tag-labels = [ ];
  };
  "dwl/window" = {
    format = "[{layout}] {title}";
    max-length = 64;
    rewrite = {
      " \\| " = "";
    };
  };
  "wlr/taskbar" = {
    format = "{icon}";
    icon-size = 20;
    all-outputs = false;
    tooltip-format = "{title}";
    markup = true;
    on-click = "activate";
    on-click-right = "close";
    ignore-list = [
      "Rofi"
    ];
  };
  tray = {
    icon-size = 20;
    spacing = 10;
  };
  clock = {
    tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    format = "{:%d/%m/%Y, %H:%M}";
  };
  battery = {
    states = {
      warning = 30;
      critical = 15;
    };
    format = "{icon} {capacity}%";
    tooltip = false;
    format-icons = [
      "󰂎"
      "󰁻"
      "󰁽"
      "󰁿"
      "󰂁"
      "󰁹"
    ];
  };
  pulseaudio = {
    disable-scroll = true;
    format = "{icon} {volume}%";
    format-bluetooth = "{icon} {volume}%";
    format-muted = "";
    format-icons = {
      default = [
        ""
        ""
      ];
    };
    on-click = "pavucontrol";
    scroll-step = 1;
  };
}
