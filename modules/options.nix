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
  };
}
