{ pkgs, claude-code, ... }:

{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ claude-code.overlays.default ];
  };

  environment.systemPackages = with pkgs; [
    acpi
    bash
    bpftools
    bpftrace
    brightnessctl
    cpufrequtils
    curl
    dnsmasq
    file
    gdb
    htop
    jmtpfs
    jq
    libmtp
    neovim
    nmap
    pciutils
    psmisc
    tcpdump
    unzip
    wireshark
    zsh
  ];

  users.users.jibi.packages = with pkgs; [
    adwaita-icon-theme
    aerc
    appimage-run
    audacity
    autoconf
    automake
    btrfs-progs
    ccache
    pkgs.claude-code
    cmake
    diceware
    difftastic
    discord
    dnsutils
    docker-compose
    eog
    evince
    ffmpeg
    firefox
    gcc
    gcc-arm-embedded
    gedit
    gimp
    gitFull
    gnumake
    google-chrome
    gparted
    hsetroot
    imagemagick
    jujutsu
    libreoffice
    libtool
    linuxHeaders
    llvmPackages.clang
    mangowc
    marker
    mgba
    nautilus
    networkmanagerapplet
    nixfmt
    nodejs
    ollama
    pass
    pavucontrol
    pkg-config
    pulseaudio
    python3
    qmk
    qpdf
    redshift
    rofi
    ruby
    rustup
    scrot
    sqlite
    thunar
    vlc
    waybar
    websocat
    wlr-randr
    xbindkeys
    xmodmap
    xrandr
    xsecurelock
    zola
  ];

  programs = {
    zsh = {
      enable = true;
      enableBashCompletion = true;
    };

    gnupg.agent.enable = true;
    nix-ld.enable = true; # lolol
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
