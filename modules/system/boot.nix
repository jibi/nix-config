{
  lib,
  pkgs,
  ...
}:

lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-linux") {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

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
}
