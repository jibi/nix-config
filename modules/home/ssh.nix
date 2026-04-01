{ shared, ... }:

{
  home.file.".ssh/id_rsa.pub".text = shared.sshPubKey + "\n";

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      debian = {
        hostname = "192.168.122.182";
        identityFile = "~/.ssh/id_debian";
      };
    };
  };
}
