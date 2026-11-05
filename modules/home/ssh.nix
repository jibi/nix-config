{ myvars, ... }:
{
  home.file.".ssh/id_rsa.pub".text = myvars.jibiSshPubKey + "\n";

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
  };
}
