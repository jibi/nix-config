{ shared, ... }:

{
  home.file.".ssh/id_rsa.pub".text = shared.sshPubKey + "\n";

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
  };
}
