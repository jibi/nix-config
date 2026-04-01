{ pkgs, ... }:

{
  imports = [
    ../default.nix
    ./hardware-configuration.nix
  ];

  myconfig.desktop.enable = true;
  myconfig.cuda.enable = true;

  networking.hostName = "xps";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "snd_hda_intel" ];
    extraModprobeConfig = ''
      options snd_hda_intel power_save=0 power_save_controller=N
    '';
    supportedFilesystems = [
      "vfat"
      "fuse.sshfs"
    ];
  };

  networking.firewall.trustedInterfaces = [ "virbr0" ];

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "suspend";
  };

  fileSystems."/media/jibi/kb" = {
    device = "/dev/disk/by-label/RPI-RP2";
    fsType = "vfat";
    options = [
      "noauto"
      "x-systemd.automount"
      "x-systemd.device-timeout=1"
      "uid=1000"
      "gid=100"
      "umask=022"
    ];
  };

  system.stateVersion = "25.05";
}
