{ pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;

      xkb = {
        layout = "us";
        variant = "";
      };

      displayManager = {
        sessionCommands = ''
          xrdb ~/.Xresources
          xmodmap ~/.Xmodmap
          xbindkeys

          nm-applet &
          hsetroot &
        '';
      };

      windowManager.awesome.enable = true;
    };

    libinput = {
      #enable = true;
      touchpad = {
        tapping = false;
      };
    };

    displayManager = {
      gdm.enable = true;
      sessionPackages = [ pkgs.mangowc ];

      autoLogin = {
        enable = true;
        user = "jibi";
      };
    };
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  programs.xss-lock.enable = true;
  programs.xss-lock.lockerCommand = "${pkgs.xsecurelock}/bin/xsecurelock";

  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      dejavu_fonts # DejaVu Sans / Serif / Mono
      liberation_ttf # Liberation family (metric-compatible with Arial, etc.)
      noto-fonts # Unicode coverage
      noto-fonts-cjk-sans # Chinese, Japanese, Korean
      noto-fonts-color-emoji # Emoji support
      font-awesome # Icons for some applications
      corefonts # Microsoft TrueType Core Fonts
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "DejaVu Serif" ];
        sansSerif = [ "DejaVu Sans" ];
        monospace = [ "DejaVu Sans Mono" ];
      };
    };
  };

  environment.variables = {
    MOZ_USE_XINPUT2 = "1";
  };
}
