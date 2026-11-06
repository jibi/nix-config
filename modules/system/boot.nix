{
  config,
  lib,
  ...
}:
{
  options = {
    modules.bootLoader.enable = lib.mkEnableOption "systemd-boot with Plymouth and quiet boot output";
  };

  config = lib.mkIf config.modules.bootLoader.enable {
    boot = {
      loader = {
        timeout = 0;
        systemd-boot = {
          enable = true;
          consoleMode = "2";
          configurationLimit = 2;
        };
        efi.canTouchEfiVariables = true;
      };

      plymouth.enable = true;
      consoleLogLevel = 3;
      kernelParams = [
        "quiet"
        "udev.log_level=3"
        "rd.systemd.show_status=auto"
      ];
    };
  };
}
