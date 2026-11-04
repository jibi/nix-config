{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.myconfig.nvidia;
  address = lib.types.submodule {
    options = {
      bus = lib.mkOption {
        type = lib.types.ints.between 0 255;
      };
      device = lib.mkOption {
        type = lib.types.ints.between 0 31;
      };
      function = lib.mkOption {
        type = lib.types.ints.between 0 7;
      };

      prime = lib.mkOption {
        type = lib.types.str;
        description = "PCI address in NVIDIA PRIME format";
      };
      pci = lib.mkOption {
        type = lib.types.str;
        description = "PCI address in domain:bus:device.function format";
      };
    };
  };
  integratedMango = pkgs.writeShellScript "mango-integrated" ''
    set -eu
    export WLR_DRM_DEVICES="$(${pkgs.coreutils}/bin/readlink -e /dev/dri/by-path/pci-${cfg.addresses.integrated.pci}-card)"
    export __EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json
    exec mango
  '';
in
{
  options.myconfig.nvidia = {
    prime.enable = lib.mkEnableOption "prime offloading";
    passthrough.enable = lib.mkEnableOption "GPU qemu passthrough";
    cuda.enable = lib.mkEnableOption "CUDA system integration";

    enable = lib.mkEnableOption "NVIDIA GPU drivers";

    addresses = {
      integrated = lib.mkOption {
        type = address;
        description = "PCI address of the integrated GPU";
      };
      discrete = lib.mkOption {
        type = address;
        description = "PCI address of the discrete NVIDIA GPU";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      hardware = {
        graphics.enable = true;
        nvidia = {
          modesetting.enable = true;
          powerManagement.enable = true;
          nvidiaPersistenced = true;
          open = false;
        };
      };

      services.xserver.videoDrivers = [
        "modesetting"
        "nvidia"
      ];
    })

    # Add the toolkit and environment below to a CUDA dev shell when needed.
    # environment = {
    #   systemPackages = with pkgs; [ cudatoolkit ];
    #   sessionVariables =
    #     let
    #       cuda = pkgs.cudatoolkit;
    #       nvidia = config.hardware.nvidia.package;
    #       fmtdev = pkgs.fmt.dev;
    #     in {
    #       LD_LIBRARY_PATH = "${cuda}/lib:${nvidia}/lib";
    #       CUDA_PATH = "${cuda}";
    #       EXTRA_LDFLAGS = "-L${nvidia}/lib";
    #       EXTRA_CCFLAGS = "-I/usr/include";
    #       CMAKE_PREFIX_PATH = "${fmtdev}";
    #       PKG_CONFIG_PATH = "${fmtdev}/lib/pkgconfig";
    #     };
    # };

    (lib.mkIf config.myconfig.nvidia.cuda.enable {
      hardware.graphics.enable = true;

      nix.settings = {
        extra-substituters = [ "https://cache.nixos-cuda.org" ];
        extra-trusted-public-keys = [
          "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
        ];
      };
    })
    (lib.mkIf cfg.prime.enable {
      hardware.nvidia.prime = {
        offload.enable = true;
        intelBusId = cfg.addresses.integrated.prime;
        nvidiaBusId = cfg.addresses.discrete.prime;
      };
    })
    (lib.mkIf cfg.passthrough.enable {
      boot.kernelParams = [ "intel_iommu=on" ];

      services.greetd.settings = lib.mkIf config.myconfig.desktop.enable {
        initial_session.command = lib.mkForce "${integratedMango}";
        default_session.command = lib.mkForce "${integratedMango}";
      };

      environment.systemPackages = [
        (pkgs.writeShellApplication {
          name = "gpu-passthrough";
          runtimeInputs = with pkgs; [
            coreutils
            kmod
            psmisc
            systemd
          ];
          text = ''
            exit_() {
              printf '%s\n' "$2"
              exit "$1"
            }

            if [[ "$#" != 1 || ( "''${1-}" != on && "''${1-}" != off ) ]]; then
              exit_ 2 "Usage: gpu-passthrough on|off"
            fi

            if [[ "$EUID" != 0 ]]; then
              exit_ 1 "Run this command with sudo."
            fi

            gpu=${cfg.addresses.discrete.pci}
            device="/sys/bus/pci/devices/$gpu"
            current=$(basename "$(readlink -f "$device/driver")")

            if [[ "$1" == on ]]; then
              if [[ "$current" == vfio-pci ]]; then
                exit_ 0 "$gpu already belongs to vfio-pci."
              fi

              if [[ "$current" != nvidia ]]; then
                exit_ 1 "Expected nvidia driver, found $current; refusing to switch."
              fi

              modprobe vfio-pci
              systemctl stop nvidia-persistenced.service
              if fuser /dev/nvidia0 /dev/nvidiactl; then
                systemctl start nvidia-persistenced.service
                exit_ 1 "GPU still has host clients; close them before switching."
              fi

              printf 'vfio-pci\n' > "$device/driver_override"
              printf '%s\n' "$gpu" > "$device/driver/unbind"
              printf '%s\n' "$gpu" > /sys/bus/pci/drivers_probe
              [[ "$(basename "$(readlink -f "$device/driver")")" == vfio-pci ]]
            else
              if [[ "$current" == nvidia ]]; then
                systemctl start nvidia-persistenced.service
                exit_ 0 "$gpu already belongs to nvidia."
              fi

              if [[ "$current" != vfio-pci ]]; then
                exit_ 1 "Expected vfio-pci driver, found $current; refusing to switch."
              fi

              group=$(basename "$(readlink -f "$device/iommu_group")")

              if [[ -e "/dev/vfio/$group" ]] && fuser "/dev/vfio/$group"; then
                exit_ 1 "GPU is assigned to a process; stop the VM first."
              fi

              modprobe nvidia
              printf '%s\n' "$gpu" > "$device/driver/unbind"
              printf '\n' > "$device/driver_override"
              printf '%s\n' "$gpu" > /sys/bus/pci/drivers_probe
              [[ "$(basename "$(readlink -f "$device/driver")")" == nvidia ]]

              systemctl start nvidia-persistenced.service
            fi
          '';
        })
      ];

      home-manager.users.jibi.programs.zsh.initContent = ''
        _gpu_passthrough() {
          _arguments '1:passthrough state:(on off)'
        }
        compdef _gpu_passthrough gpu-passthrough
      '';
    })
  ];
}
