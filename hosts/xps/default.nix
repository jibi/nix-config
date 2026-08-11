{ pkgs, lib, ... }:

{
  imports = [
    ../default.nix
    ./hardware-configuration.nix
  ];

  myconfig = {
    desktop.enable = true;
    display.scale = "2.5";
    wifi.backend = "nm";
    cuda.enable = false;
    virtualisation.enable = false;
  };

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];

    plymouth.enable = true;

    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "rd.systemd.show_status=auto"
    ];

    loader.timeout = 0;

    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [ "snd_hda_intel" ];
    extraModprobeConfig = ''
      options snd_hda_intel power_save=0 power_save_controller=N
    '';
    supportedFilesystems = [
      "vfat"
      "fuse.sshfs"
    ];
  };

  fileSystems."/media/jibi/kb" = {
    device = lib.mkForce "/dev/disk/by-label/RPI-RP2";
    fsType = lib.mkForce "vfat";
    options = [
      "noauto"
      "x-systemd.automount"
      "x-systemd.device-timeout=1"
      "uid=1000"
      "gid=100"
      "umask=022"
    ];
  };

  networking = {
    hostName = "xps";
  };

  services = {
    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchDocked = "ignore";
      HandleLidSwitchExternalPower = "suspend";
    };

    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="05c6", ATTRS{idProduct}=="9008", MODE="0666"
    '';

    udev.packages = [
      (pkgs.writeTextFile {
        name = "vial-udev-rules";
        destination = "/etc/udev/rules.d/59-vial.rules";
        text = ''
          KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
        '';
      })
    ];
  };

  system.stateVersion = "26.11";
}
