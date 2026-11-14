{ myvars, jetpack, ... }:

{
  imports = [
    ./hardware-configuration.nix
    jetpack.nixosModules.default
  ];

  modules = {
    desktop.enable = false;
    bootLoader.enable = true;
    networking.wifi.backend = "wpa_supplicant";
    nvidia.cuda.enable = true;
    virtualisation.enable = false;
  };

  hardware = {
    graphics.enable = true;
    nvidia-jetpack = {
      enable = true;
      majorVersion = "7";
      som = "orin-nano";
      carrierBoard = "devkit";
      configureCuda = true;
    };
  };

  boot = {
    kernelParams = [ "plymouth.ignore-serial-consoles" ];
  };

  networking = {
    hostName = "jetson";
    useDHCP = true;
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  users.users.${myvars.username}.extraGroups = [ "video" ];

  home-manager.users.${myvars.username}.home.enableNixpkgsReleaseCheck = false;
  system.stateVersion = "26.05";
}
