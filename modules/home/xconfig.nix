{ ... }:

{
  xresources.properties = {
    "Xft.dpi" = 240;
    "Xcursor.size" = 48;
    "Xcursor.theme" = "Adwaita";
  };

  home.file.".Xmodmap".text = ''
    keycode 64 = Alt_L
    keycode 133 = Super_L
    remove Mod1 = Alt_L
    remove Mod4 = Super_L
    add Mod1 = Super_L
    add Mod4 = Alt_L
  '';

  home.file.".xbindkeysrc".text = ''
    # Increase volume
    "pactl set-sink-volume @DEFAULT_SINK@ +2500"
       XF86AudioRaiseVolume

    # Decrease volume
    "pactl set-sink-volume @DEFAULT_SINK@ -2500"
       XF86AudioLowerVolume

    # Mute volume
    "pactl set-sink-mute @DEFAULT_SINK@ toggle"
       XF86AudioMute

    "brightnessctl s '+5%'"
       XF86MonBrightnessUp

    "brightnessctl s '5%-'"
       XF86MonBrightnessDown
  '';

  home.file."bin/int.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      xrandr \
        --output DP-1 --off \
        --output DP-2 --off \
        --output eDP-1 --primary --mode 3840x2400 --pos 0x0 --rotate normal -d :0

      sleep 1s

      echo "Xft.dpi: 240" | xrdb -merge

      [ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap

      echo 'awesome.restart()' | awesome-client
    '';
  };

  home.file."bin/ext.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      ext_outputs=$(xrandr | awk '/ connected/{print $1}' | grep -v '^eDP-1$')

      if [ -z "$ext_outputs" ]; then
        echo "No external monitor detected. Exiting."
        exit 1
      fi

      echo "External outputs detected: $ext_outputs"

      ext_output=$(echo "$ext_outputs" | head -n1)

      xrandr \
        --output "$ext_output" \
        --primary --mode 3840x2160 --pos 0x0 --rotate normal --dpi 192 \
        --output eDP-1 --off

      sleep 1s

      echo "Xft.dpi: 192" | xrdb -merge

      [ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap

      echo 'awesome.restart()' | awesome-client 2>/dev/null
    '';
  };
}
