{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.myconfig.desktop.enable {
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
