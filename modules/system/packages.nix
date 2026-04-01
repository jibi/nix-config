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

  environment.systemPackages = with pkgs; [
    bash
    bpftools
    bpftrace
    curl
    dnsmasq
    file
    gdb
    htop
    jq
    neovim
    nmap
    pciutils
    psmisc
    ripgrep
    tcpdump
    unzip
    wireshark
    zsh
  ];

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
