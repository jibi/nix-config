{
  config,
  lib,
  pkgs,
  ...
}:

let
  intel = {
    bus = 0;
    device = 2;
    function = 0;
  };
  nvidia = {
    bus = 1;
    device = 0;
    function = 0;
  };

  hex2 = n: lib.fixedWidthString 2 "0" (lib.toLower (lib.toHexString n));
  toPrime =
    {
      bus,
      device,
      function,
    }:
    "PCI:${toString bus}:${toString device}:${toString function}";
  toPci =
    {
      bus,
      device,
      function,
    }:
    "0000:${hex2 bus}:${hex2 device}.${lib.toLower (lib.toHexString function)}";
in
lib.mkIf config.myconfig.cuda.enable {
  specialisation.cuda.configuration =
    { config, pkgs, ... }:
    lib.mkMerge [
      {
        system.nixos.label = "nixos-cuda";

        nix.settings = {
          substituters = [
            "https://cache.nixos-cuda.org"
          ];
          trusted-public-keys = [
            "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
          ];
        };

        nixpkgs.config.allowBroken = true;

        hardware = {
          graphics.enable = true;

          nvidia = {
            modesetting.enable = true;
            powerManagement.enable = true;
            nvidiaPersistenced = true;
            open = false;

            prime = {
              offload.enable = true;

              intelBusId = toPrime intel;
              nvidiaBusId = toPrime nvidia;
            };
          };

          nvidia-container-toolkit.enable = true;
        };

        services.xserver.videoDrivers = [
          "modesetting"
          "nvidia"
        ];

        environment = {
          systemPackages = with pkgs; [ cudatoolkit ];

          sessionVariables =
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
      (lib.mkIf config.myconfig.cuda.passthrough {
        boot.kernelParams = [ "intel_iommu=on" ];

        services.greetd.settings =
          let
            intelMango = pkgs.writeShellScript "mango-intel" ''
              set -eu

              # restrict wlroots display devices to the Intel GPU.
              export WLR_DRM_DEVICES="$(${pkgs.coreutils}/bin/readlink -e /dev/dri/by-path/pci-${toPci intel}-card)"

              # restrict EGL to Mesa so NVIDIA's EGL library doesn't open the GPU during discovery:
              #
              # ls /run/opengl-driver/share/glvnd/egl_vendor.d/
              # 10_nvidia.json  50_mesa.json
              export __EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json

              exec mango
            '';
          in
          {
            initial_session.command = lib.mkForce "${intelMango}";
            default_session.command = lib.mkForce "${intelMango}";
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

              gpu=${toPci nvidia}
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
