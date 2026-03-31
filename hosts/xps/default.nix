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

  home-manager.users.jibi.home.file.".ssh/id_rsa.pub".text =
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCNtyf3z93491mDKzb+0P+Yb942u99YS168AorgXxY2YgiRwLRmXDSJybTzq8BAcfxt2grokom7PVry9BK47OIhOFgxEn+C3TJ8By0o/IFn8j8SwYGV6x1I4ut1fKuXpgz3Z4FJmx8P1EaVy0Ii6P+qtxfM7Xlxgn9I9lPBoLkDSTlW4iZLVjQrMAKEF5PI/9jvoDpdwPBIxJ1V3OwgCn6qBNdH/Lt1pytvDLb3m14Pax5MRI78F8HhnoycDWTiQ4qXQCHktsL84NMWS2YDJqi/1w0ItV7YVqF7RY1q+M7N4NqzN1ZDWHh/5FlEuh/wnzmLsgZhj6ppCgnxHtK6KYh cardno:20_892_380\n";

  system.stateVersion = "25.05";
}
