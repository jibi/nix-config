{ lib, pkgs, ... }:

lib.mkIf (pkgs.system == "x86_64-linux") {
  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "2";
      configurationLimit = 5;
    };

    efi.canTouchEfiVariables = true;
  };
}
