{
  myvars,
  config,
  lib,
  pkgs,
  ...
}:
let
  volumes = config.modules.storage.volumes;
  user = config.users.users.${myvars.username};
  group = config.users.groups.${user.group};

  volumeType = lib.types.submodule (
    { name, ... }:
    {
      options = {
        label = lib.mkOption {
          type = lib.types.str;
          default = name;
        };
        fsType = lib.mkOption {
          type = lib.types.str;
          default = "btrfs";
        };
        options = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ "noauto" ];
        };
        luks.enable = lib.mkEnableOption "LUKS encryption";
      };
    }
  );

  toFileSystems =
    volumes:
    lib.mapAttrs' (
      name: volume:
      lib.nameValuePair "/mnt/${name}" {
        device = if volume.luks.enable then "/dev/mapper/${name}" else "/dev/disk/by-label/${volume.label}";
        inherit (volume) fsType options;
      }
    ) volumes;

  mountVolume = pkgs.writeShellApplication {
    name = "mount-volume";
    runtimeInputs = with pkgs; [
      pass
      coreutils
      cryptsetup
      util-linux
    ];
    text = ''
      if [ "$#" -ne 1 ]; then
        echo "usage: mount-volume <name>" >&2
        exit 1
      fi
      name="$1"

      case "$name" in
        ${lib.concatMapAttrsStringSep "\n" (
          name: volume:
          let
            pattern = lib.escapeShellArg name;
            device = lib.escapeShellArg "/dev/disk/by-label/${volume.label}";
            mountPoint = lib.escapeShellArg "/mnt/${name}";
            luks = lib.boolToString volume.luks.enable;
          in
          "${pattern}) device=${device}; mount_point=${mountPoint}; luks=${luks} ;;"
        ) volumes}
        *) echo "Unknown volume: $name" >&2; exit 1 ;;
      esac

      if findmnt --mountpoint "$mount_point" --types noautofs --noheadings >/dev/null; then
        exit 0
      fi

      sudo -v
      opened_luks=false
      if "$luks"; then
        if ! sudo cryptsetup status "$name" >/dev/null; then
          pass show "luks/$name" | base64 --decode | sudo cryptsetup open "$device" "$name" --key-file=-
          opened_luks=true
        fi
      fi

      if ! sudo mount "$mount_point"; then
        if "$opened_luks"; then
          sudo cryptsetup close "$name"
        fi
        exit 1
      fi
    '';
  };

  umountVolume = pkgs.writeShellApplication {
    name = "umount-volume";
    runtimeInputs = with pkgs; [
      cryptsetup
      util-linux
    ];
    text = ''
      if [ "$#" -ne 1 ]; then
        echo "usage: umount-volume <name>" >&2
        exit 1
      fi
      name="$1"

      case "$name" in
        ${lib.concatMapAttrsStringSep "\n" (
          name: volume:
          let
            pattern = lib.escapeShellArg name;
            mountPoint = lib.escapeShellArg "/mnt/${name}";
            luks = lib.boolToString volume.luks.enable;
          in
          "${pattern}) mount_point=${mountPoint}; luks=${luks} ;;"
        ) volumes}
        *) echo "Unknown volume: $name" >&2; exit 1 ;;
      esac

      sudo umount "$mount_point"
      if "$luks"; then
        sudo cryptsetup close "$name"
      fi
    '';
  };

  shellCompletion = pkgs.writeTextDir "share/zsh/site-functions/_storage_volumes" ''
    #compdef mount-volume umount-volume
    compadd -- ${lib.escapeShellArgs (builtins.attrNames volumes)}
  '';
in
{
  options = {
    modules.storage.volumes = lib.mkOption {
      default = { };
      type = lib.types.attrsOf volumeType;
    };
  };

  config = {
    modules.storage.volumes = lib.mkIf config.modules.desktop.enable {
      t7.luks.enable = true;
      barracuda.luks.enable = true;
      m3.luks.enable = true;
      sv35.luks.enable = true;

      kb = {
        label = "RPI-RP2";
        fsType = "vfat";
        options = [
          "noauto"
          "x-systemd.automount"
          "uid=${toString user.uid}"
          "gid=${toString group.gid}"
          "umask=022"
        ];
      };
    };

    fileSystems = toFileSystems volumes;

    boot.supportedFilesystems = lib.mkIf config.modules.desktop.enable [ "fuse.sshfs" ];

    environment.systemPackages = lib.optionals (volumes != { }) [
      mountVolume
      umountVolume
      shellCompletion
    ];
  };
}
