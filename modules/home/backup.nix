{ pkgs, homeBin, ... }:

let
  mountLuks = pkgs.writeShellScript "mount-luks" ''
    set -e

    if [ -z "$1" ]; then
      echo "usage: mount-luks <name>" >&2
      exit 1
    fi
    name="$1"

    sudo systemctl start "systemd-cryptsetup@$name"
    sudo mount "/mnt/$name"
  '';

  umountLuks = pkgs.writeShellScript "umount-luks" ''
    set -e

    if [ -z "$1" ]; then
      echo "usage: umount-luks <name>" >&2
      exit 1
    fi
    name="$1"

    sudo umount "/mnt/$name"
    sudo systemctl stop "systemd-cryptsetup@$name"
  '';

  doBackup = pkgs.writeShellScript "do-backup" ''
    set -e

    if [ -z "$1" ]; then
      echo "usage: do-backup <name>" >&2
      exit 1
    fi
    name="$1"
    mount_path="/mnt/$name"

    ${mountLuks} "$name"
    sudo rsync -aAXv --delete --delete-excluded --exclude-from=/home/jibi/.rsync-exclude /home/jibi/ "$mount_path/current/home/jibi/"
    sudo btrfs subvolume snapshot "$mount_path/current" "$mount_path/snapshots/$(date "+%Y_%m_%d")"
    ${umountLuks} "$name"
  '';
in
{
  home.file = {
    "${homeBin}/mount-luks".source = mountLuks;
    "${homeBin}/umount-luks".source = umountLuks;
    "${homeBin}/do-backup".source = doBackup;
  };
}
