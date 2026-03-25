{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.myconfig.cuda.enable {
  specialisation.cuda.configuration = {
    system.nixos.label = "nixos-cuda";

    nixpkgs.config.allowBroken = true;

    hardware.graphics.enable = true;
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      nvidiaPersistenced = true;
      open = false;
    };

    environment.systemPackages = with pkgs; [ cudatoolkit ];

    services.xserver.videoDrivers = [
      "modesetting"
      "nvidia"
    ];

    hardware.nvidia.prime = {
      offload.enable = true;

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    environment.sessionVariables =
      let
        cuda = pkgs.cudatoolkit;
        nvidia = config.hardware.nvidia.package;
        fmtdev = pkgs.fmt.dev;
      in
      {
        LD_LIBRARY_PATH = "${cuda}/lib:${nvidia}/lib";
        CUDA_PATH = "${cuda}";
        EXTRA_LDFLAGS = "-L${nvidia}/lib";
        EXTRA_CCFLAGS = "-I/usr/include";
        CMAKE_PREFIX_PATH = "${fmtdev}";
        PKG_CONFIG_PATH = "${fmtdev}/lib/pkgconfig";
      };
  };
}
