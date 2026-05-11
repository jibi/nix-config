{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./desktop-packages.nix
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages =
    (with pkgs; [
      bash
      curl
      dnsmasq
      file
      htop
      jq
      neovim
      nmap
      pciutils
      psmisc
      ripgrep
      tcpdump
      unzip
      zsh
    ])
    ++ lib.optionals config.myconfig.desktop.enable (
      with pkgs;
      [
        bpftools
        bpftrace
        gdb
        wireshark
      ]
    );

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
    nix-ld.enable = true;
  };

  virtualisation = lib.mkIf config.myconfig.virtualisation.enable {
    docker.enable = true;
    libvirtd = {
      enable = true;
      qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
    };
  };

  services = {
    fwupd.enable = lib.mkIf config.myconfig.desktop.enable true;
    pcscd.enable = true;
  };
}
