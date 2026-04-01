{
  config,
  lib,
  pkgs,
  shared,
  ...
}:
{
  users.users.jibi = {
    isNormalUser = true;
    description = "Jibi";
    extraGroups = [
      "networkmanager"
      "wheel"
    ]
    ++ lib.optionals config.virtualisation.docker.enable [ "docker" ]
    ++ lib.optionals config.virtualisation.libvirtd.enable [ "libvirtd" ]
    ++ lib.optionals config.services.xserver.enable [
      "plugdev"
      "video"
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [ shared.sshPubKey ];
  };

  programs.zsh.enable = true;
}
