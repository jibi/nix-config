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
    settings = builtins.readFile ./config.conf;
    autostart_sh = "";
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
