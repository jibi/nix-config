{
  config,
  pkgs,
  lib,
  osConfig,
  homeBin,
  ...
}:
let
  home = config.home.homeDirectory;
  doBackup = pkgs.writeShellApplication {
    name = "do-backup";
    runtimeInputs = with pkgs; [
      rsync
      btrfs-progs
      coreutils
    ];
    text = ''

      if [ "$#" -ne 1 ]; then
        echo "usage: do-backup <name>" >&2
        exit 1
      fi
      name="$1"
      mount_path="/mnt/$name"

      mount-volume "$name"
      # Read the exclude file as the invoking user; only rsync needs root.
      # shellcheck disable=SC2024
      sudo rsync -aAXv --delete --delete-excluded --exclude-from=- ${lib.escapeShellArg "${home}/"} "$mount_path/current"${lib.escapeShellArg "${home}/"} < ${lib.escapeShellArg "${home}/.rsync-exclude"}
      sudo btrfs subvolume snapshot "$mount_path/current" "$mount_path/snapshots/$(date "+%Y_%m_%d")"
      umount-volume "$name"
    '';
  };
in
lib.mkIf osConfig.modules.desktop.enable {
  home.file."${homeBin}/do-backup".source = "${doBackup}/bin/do-backup";
  programs.zsh.initContent = ''
    compdef _storage_volumes do-backup
  '';
}
