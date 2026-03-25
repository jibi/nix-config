{ lib, ... }:

{
  options.myconfig = {
    desktop.enable = lib.mkEnableOption "desktop environment";
    cuda.enable = lib.mkEnableOption "CUDA support";
  };
}
