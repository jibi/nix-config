{ nixpkgs, lib, ... }:

{
  imports = [
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
  ];

  sdImage = {
    compressImage = false;
    populateFirmwareCommands = lib.mkAfter ''
      config=firmware/config.txt
      chmod u+w $config
      cat >> $config <<EOF
      start_x=0
      gpu_mem=16
      EOF
      chmod u-w $config
    '';
    populateRootCommands =
      let
        keys = /. + builtins.getEnv "HOME" + "/nix-config/tmp-keys/rpi";
      in
      lib.mkAfter ''
        mkdir -p ./files/etc/ssh
        install -m 600 ${keys}/ssh_host_ed25519_key ./files/etc/ssh/ssh_host_ed25519_key
        install -m 644 ${keys}/ssh_host_ed25519_key.pub ./files/etc/ssh/ssh_host_ed25519_key.pub
      '';
  };
}
