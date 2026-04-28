{ lib, ... }:

{
  options.myconfig = {
    desktop.enable = lib.mkEnableOption "desktop environment";
    cuda.enable = lib.mkEnableOption "CUDA support";
    virtualisation.enable = lib.mkEnableOption "virtualisation (docker, libvirtd)";
    display.scale = lib.mkOption {
      type = lib.types.str;
      default = "1.0";
    };
    wifi.backend = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "nm"
          "wpa_supplicant"
        ]
      );
      default = null;
    };
  };
}
