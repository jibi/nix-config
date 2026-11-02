{ jetpack, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../default.nix
    jetpack.nixosModules.default
  ];

  myconfig = {
    desktop.enable = false;
    wifi.backend = "wpa_supplicant";
    cuda.enable = false;
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

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "jetson";
    useDHCP = true;
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  users.users.jibi.extraGroups = [ "video" ];

  home-manager.users.jibi.home.enableNixpkgsReleaseCheck = false;
  system.stateVersion = "26.05";
}
