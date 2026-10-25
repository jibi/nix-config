{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.myconfig.desktop.enable {
  boot.supportedFilesystems = [
    "vfat"
    "fuse.sshfs"
  ];

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

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;

      settings = {
        General = {
          Experimental = true;
          FastConnectable = true;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };

    gpgSmartcards = {
      enable = true;
    };
  };
}
