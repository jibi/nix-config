{
  config,
  lib,
  mylib,
  pkgs,
  ...
}:

{
  imports = [
    ../default.nix
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
      networking.wifi.backend = "nm";
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

    services = {
      fprintd = {
        enable = true;
        tod = {
          enable = true;
          driver = pkgs.libfprint-2-tod1-goodix;
        };
      };
    };

    system.stateVersion = "26.11";
  };
}
