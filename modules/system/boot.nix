{ lib, pkgs, ... }:

lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-linux") {
  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "2";
      configurationLimit = 2;
    };

    efi.canTouchEfiVariables = true;
  };
}
