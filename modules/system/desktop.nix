{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    modules.desktop = {
      enable = lib.mkEnableOption "desktop environment";
      display.scale = lib.mkOption {
        type = lib.types.str;
        default = "1.0";
      };
    };
  };

  config = lib.mkIf config.modules.desktop.enable {
    modules = {
      backup.enable = true;
      secrets.tools.enable = true;
    };

    programs = {
      mango.enable = true;
      virt-manager.enable = true;
    };

    services = {
      libinput.touchpad.tapping = false;

      greetd = {
        enable = true;

        settings = rec {
          initial_session = {
            command = "mango";
            user = "jibi";
          };

          default_session = initial_session;
        };
      };

      printing = {
        enable = true;

        drivers = with pkgs; [
          samsung-unified-linux-driver
        ];
      };

      pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
      };

      udisks2.enable = true;
      gvfs.enable = true;

      blueman.enable = true;
    };

    security = {
      rtkit.enable = true;
    };

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
  };
}
