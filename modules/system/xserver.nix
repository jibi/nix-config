{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.myconfig.desktop.enable {
  services = {
    xserver = {
      enable = true;

      xkb = {
        layout = "us";
        variant = "";
      };
    };

    libinput.touchpad.tapping = false;

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
      nerd-fonts.dejavu-sans-mono
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
}
