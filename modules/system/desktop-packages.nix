{ pkgs, claude-code, ... }:

{
  nixpkgs.overlays = [ claude-code.overlays.default ];

  environment.systemPackages = with pkgs; [
    acpi
    bash
    bpftools
    bpftrace
    brightnessctl
    cpufrequtils
    dnsmasq
    file
    gdb
    htop
    jmtpfs
    libmtp
    nmap
    pciutils
    psmisc
    tcpdump
    unzip
    wireshark
    zsh
  ];

  programs = {
    zsh.enableBashCompletion = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
    virt-manager.enable = true;
  };

  virtualisation = {
    docker.enable = true;
    libvirtd = {
      enable = true;
      qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
    };
  };

  services = {
    printing = {
      enable = true;
      drivers = with pkgs; [
        samsung-unified-linux-driver
      ];
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    fwupd.enable = true;

    udisks2.enable = true;
    gvfs.enable = true;

    pcscd.enable = true;
    blueman.enable = true;
  };

  security.rtkit.enable = true;
}
