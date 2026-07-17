{
  lib,
  pkgs,
  llm-agents,
  rust-overlay,
  ...
}:

let
  llmAgentsPkgs = llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
  rustPkgs = pkgs.extend rust-overlay.overlays.default;
in
{
  home.packages = with pkgs; [
    acpi
    adwaita-icon-theme
    aerc
    appimage-run
    audacity
    autoconf
    automake
    brightnessctl
    btrfs-progs
    linuxPackages.cpupower
    ccache
    llmAgentsPkgs.claude-code
    cargo-expand
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
    ghc
    gimp
    gnumake
    gparted
    hsetroot
    imagemagick
    jmtpfs
    jujutsu
    libmtp
    libreoffice
    libtool
    linuxHeaders
    (lib.hiPrio llvmPackages.clang)
    marker
    marp-cli
    mgba
    nautilus
    networkmanagerapplet
    nixos-anywhere
    nodejs
    ollama
    pass
    pavucontrol
    pkg-config
    pulseaudio
    python3
    qmk
    qpdf
    ruby
    rustPkgs.rust-bin.nightly.latest.default
    scrot
    signal-desktop
    sqlite
    swaybg
    trace-cmd
    vlc
    websocat
    wlr-randr
    xbindkeys
    xmodmap
    xrandr
    xsecurelock
    zola
  ];

  services.gammastep = {
    enable = true;
    latitude = 46.4983;
    longitude = 11.3548;
    temperature.night = 2200;
    tray = true;
  };
}
