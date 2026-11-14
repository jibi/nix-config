{
  config,
  lib,
  pkgs,
  myvars,
  ...
}:
{
  users.users.${myvars.username} = {
    uid = 1000;
    isNormalUser = true;
    description = "Jibi";
    extraGroups = [
      "networkmanager"
      "wheel"
    ]
    ++ lib.optionals config.virtualisation.docker.enable [ "docker" ]
    ++ lib.optionals config.virtualisation.libvirtd.enable [ "libvirtd" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [ myvars.sshPubkey ];
  };

  programs.zsh.enable = true;
}
