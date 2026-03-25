{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.myconfig.desktop.enable {
  programs = {
    mango.enable = true;
    virt-manager.enable = true;
  };

  services = {
    printing = {
      enable = true;
      drivers = with pkgs; [
        samsung-unified-linux-driver
      ];
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    udisks2.enable = true;
    gvfs.enable = true;

    blueman.enable = true;
  };

  security.rtkit.enable = true;
  security.pam.services.waylock = { };
}
