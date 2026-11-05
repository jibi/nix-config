{
  config,
  lib,
  pkgs,
  myvars,
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
    ++ lib.optionals config.virtualisation.libvirtd.enable [ "libvirtd" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [ myvars.jibiSshPubKey ];
  };

  programs.zsh.enable = true;
}
