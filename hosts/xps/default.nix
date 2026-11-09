{
  config,
  lib,
  mylib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  options = {
    modules.xps.nvidia.enable = lib.mkEnableOption "xps nixos-nvidia specialisation";
  };

  config = {
    modules = {
      xps.nvidia.enable = false;
      desktop.enable = true;
      desktop.display.scale = "2.5";
      duckstation.qtScaleFactor = "1.25";
      networking.wifi.backend = "nm";
      networking.wireguard.enable = true;
      fingerprint = {
        enable = true;
        todDriver = pkgs.libfprint-2-tod1-goodix;
      };
      virtualisation.enable = false;
    };

    specialisation = lib.mkIf config.modules.xps.nvidia.enable {
      nvidia.configuration = {
        system.nixos.label = "nixos-nvidia";

        modules.nvidia = {
          enable = true;

          addresses = {
            integrated = mylib.pciAddress 0 2 0;
            discrete = mylib.pciAddress 1 0 0;
          };

          prime.enable = true;
          passthrough.enable = true;
          cuda.enable = true;
        };
      };
    };

    boot = {
      binfmt.emulatedSystems = [ "aarch64-linux" ];

      kernelModules = [ "snd_hda_intel" ];
      extraModprobeConfig = ''
        options snd_hda_intel power_save=0 power_save_controller=N
      '';
    };

    networking = {
      hostName = "xps";
    };

    system.stateVersion = "26.11";
  };
}
