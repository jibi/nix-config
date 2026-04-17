{
  config,
  pkgs,
  mango,
  ...
}:

{
  imports = [ mango.hmModules.mango ];

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 32;
    gtk.enable = true;
  };

  home.packages = [ pkgs.waylock ];

  xdg.desktopEntries.discord-wayland = {
    categories = [
      "Network"
      "InstantMessaging"
    ];
    exec = "Discord --enable-features=UseOzonePlatform --ozone-platform=wayland";
    name = "Discord Wayland";
    genericName = "All-in-one cross-platform voice and text chat for gamers";
    icon = "discord";
    mimeType = [ "x-scheme-handler/discord" ];
    type = "Application";
  };

  home.file."bin/lock" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      exec ${pkgs.waylock}/bin/waylock -init-color 0x000000 -input-color 0x000000 -fail-color 0xFF0000
    '';
  };

  wayland.windowManager.mango = {
    enable = true;
    settings = {
      # Window effects
      blur = 0;
      shadows = 0;
      border_radius = 0;
      focused_opacity = 1.0;
      unfocused_opacity = 1.0;

      # Animations
      animations = 0;
      layer_animations = 0;

      # Scroller Layout
      scroller_default_proportion = 0.8;
      scroller_focus_center = 0;
      scroller_prefer_center = 0;
      scroller_proportion_preset = "0.5,0.8,1.0";

      # Layout cycle
      circle_layout = "tile,vertical_tile,grid,monocle";

      # Master-Stack Layout
      new_is_master = 0;
      default_mfact = 0.50;
      default_nmaster = 1;
      smartgaps = 0;

      # Overview
      hotarea_size = 0;
      enable_hotarea = 0;

      # Misc
      sloppyfocus = 0;
      warpcursor = 0;
      cursor_size = 32;
      focus_on_activate = 0;

      # Keyboard
      repeat_rate = 25;
      repeat_delay = 600;
      xkb_rules_layout = "us";

      # Trackpad
      tap_to_click = 0;
      tap_and_drag = 1;
      drag_lock = 1;
      trackpad_natural_scrolling = 0;
      axis_scroll_factor = 0.5;
      disable_while_typing = 1;
      accel_speed = -0.2;

      # Appearance
      gappih = 0;
      gappiv = 0;
      gappoh = 0;
      gappov = 0;
      borderpx = 0;
      rootcolor = "0x000000ff";
      bordercolor = "0x000000ff";
      focuscolor = "0x000000ff";

      monitorrule = [
        "name:^eDP-1$,scale:2.5"
        "name:^DP-2$,scale:2"
      ];

      tagrule = [
        "id:1,layout_name:tile"
        "id:2,layout_name:monocle"
        "id:3,layout_name:tile"
        "id:4,layout_name:tile"
        "id:5,layout_name:tile"
        "id:6,layout_name:tile"
        "id:7,layout_name:tile"
        "id:8,layout_name:tile"
        "id:9,layout_name:tile"
      ];

      bind = [
        # Reload config
        "ALT+CTRL,r,reload_config"

        # Spawn
        "ALT,p,spawn,rofi -show drun"
        "ALT,Return,spawn,alacritty"

        # Kill / Quit
        "ALT+SHIFT,c,killclient,"
        "ALT+SHIFT,q,quit"

        # Focus
        "ALT,h,focusdir,left"
        "ALT,j,focusdir,down"
        "ALT,k,focusdir,up"
        "ALT,l,focusdir,right"
        "ALT,Tab,focusstack,1"
        "ALT+SHIFT,Tab,focusstack,-1"

        # Swap windows
        "ALT+SHIFT,j,exchange_client,down"
        "ALT+SHIFT,k,exchange_client,up"
        "ALT+SHIFT,h,exchange_client,left"
        "ALT+SHIFT,l,exchange_client,right"

        # Window state
        "ALT,f,togglefullscreen"
        "ALT+CTRL,space,togglefloating,"
        "ALT,m,togglemaximizescreen,"
        "ALT,n,minimized,"
        "ALT+CTRL,n,restore_minimized"
        "ALT+CTRL,Return,zoom"

        # Layout
        "ALT,space,switch_layout"
        "ALT,Left,setmfact,-0.05"
        "ALT,Right,setmfact,0.05"
        "ALT+CTRL,h,incnmaster,1"
        "ALT+CTRL,l,incnmaster,-1"

        # Tag switch
        "ALT,1,view,1,0"
        "ALT,2,view,2,0"
        "ALT,3,view,3,0"
        "ALT,4,view,4,0"
        "ALT,5,view,5,0"
        "ALT,6,view,6,0"
        "ALT,7,view,7,0"
        "ALT,8,view,8,0"
        "ALT,9,view,9,0"

        # Move window to tag
        "ALT+SHIFT,1,tag,1,0"
        "ALT+SHIFT,2,tag,2,0"
        "ALT+SHIFT,3,tag,3,0"
        "ALT+SHIFT,4,tag,4,0"
        "ALT+SHIFT,5,tag,5,0"
        "ALT+SHIFT,6,tag,6,0"
        "ALT+SHIFT,7,tag,7,0"
        "ALT+SHIFT,8,tag,8,0"
        "ALT+SHIFT,9,tag,9,0"

        # Toggle tag view
        "ALT+CTRL,1,toggleview,1,0"
        "ALT+CTRL,2,toggleview,2,0"
        "ALT+CTRL,3,toggleview,3,0"
        "ALT+CTRL,4,toggleview,4,0"
        "ALT+CTRL,5,toggleview,5,0"
        "ALT+CTRL,6,toggleview,6,0"
        "ALT+CTRL,7,toggleview,7,0"
        "ALT+CTRL,8,toggleview,8,0"
        "ALT+CTRL,9,toggleview,9,0"

        # Navigate tags
        "ALT+SUPER,h,viewtoleft,0"
        "ALT+SUPER,l,viewtoright,0"

        # Focus monitor
        "ALT+CTRL,j,focusmon,left"
        "ALT+CTRL,k,focusmon,right"

        # Overview
        "ALT,o,toggleoverview,"

        # Toggle waybar
        "ALT,b,spawn,pkill --signal USR1 waybar"

        # Lock screen
        "ALT+CTRL,s,spawn,/home/jibi/bin/lock"

        # Volume/Brightness
        "NONE,XF86AudioRaiseVolume,spawn,pactl set-sink-volume @DEFAULT_SINK@ +2500"
        "NONE,XF86AudioLowerVolume,spawn,pactl set-sink-volume @DEFAULT_SINK@ -2500"
        "NONE,XF86AudioMute,spawn,pactl set-sink-mute @DEFAULT_SINK@ toggle"
        "NONE,XF86MonBrightnessUp,spawn,brightnessctl s '+5%'"
        "NONE,XF86MonBrightnessDown,spawn,brightnessctl s '5%-'"
      ];

      mousebind = [
        "ALT,btn_left,moveresize,curmove"
        "ALT,btn_right,moveresize,curresize"
      ];
    };

    autostart_sh = ''
      waybar &
      nm-applet &
      blueman-applet &
      dbus-update-activation-environment --all
      systemctl --user start swayidle
    '';
  };

  programs = {
    waybar = {
      enable = true;
      style = builtins.readFile ./waybar.css;
      settings.mainBar = import ./waybar.nix;
    };

    rofi = {
      enable = true;
      package = pkgs.rofi;
      theme = ./rofi-theme.rasi;
      extraConfig = import ./rofi.nix;
    };
  };

  services.swayidle =
    let
      lock = "${config.home.homeDirectory}/bin/lock";
      dpms = status: "${pkgs.wlopm}/bin/wlopm --${status} '*'";
    in
    {
      enable = true;
      timeouts = [
        {
          timeout = 300;
          command = lock;
        }
        {
          timeout = 300;
          command = dpms "off";
          resumeCommand = dpms "on";
        }
      ];
      events = {
        before-sleep = lock;
        after-resume = dpms "on";
      };
    };
}
