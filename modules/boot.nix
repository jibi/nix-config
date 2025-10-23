{ pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "2";
        configurationLimit = 2;
      };

      efi.canTouchEfiVariables = true;
    };

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
}
