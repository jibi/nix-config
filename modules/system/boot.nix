{ ... }:

{
  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "2";
      configurationLimit = 5;
    };

    efi.canTouchEfiVariables = true;
  };
}
