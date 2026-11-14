{ myvars, ... }:
{
  home.file.".ssh/id_rsa.pub".text = myvars.sshPubkey + "\n";

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
  };
}
