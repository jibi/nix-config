{ pkgs, ... }:

{
  imports = [
    ../default.nix
    ./hardware-configuration.nix
  ];

  myconfig = {
    desktop.enable = true;
    display.scale = "2.5";
    wifi.backend = "nm";
    cuda = {
      enable = false;
      passthrough = true;
    };
    virtualisation.enable = false;
  };

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];

    kernelModules = [ "snd_hda_intel" ];
    extraModprobeConfig = ''
      options snd_hda_intel power_save=0 power_save_controller=N
    '';
  };

  networking = {
    hostName = "xps";
  };

  services = {
    fprintd = {
      enable = true;
      tod = {
        enable = true;
        driver = pkgs.libfprint-2-tod1-goodix;
      };
    };
  };

  system.stateVersion = "26.11";
}
