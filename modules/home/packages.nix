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
    appimage-run
    audacity
    autoconf
    automake
    brightnessctl
    btrfs-progs
    linuxPackages.cpupower
    llmAgentsPkgs.codex
    cargo-expand
    cmake
    diceware
    difftastic
    discord
    dnsutils
    eog
    evince
    ffmpeg
    firefox
    gcc
    gedit
    ghc
    gimp
    google-chrome
    gnumake
    gparted
    imagemagick
    jujutsu
    libmtp
    libreoffice
    libtool
    linuxHeaders
    (lib.hiPrio llvmPackages.clang)
    marp-cli
    mgba
    nautilus
    networkmanagerapplet
    nixos-anywhere
    llmAgentsPkgs.opencode
    pass
    pavucontrol
    pkg-config
    pulseaudio
    python3
    qmk
    qpdf
    ruby
    rustPkgs.rust-bin.nightly.latest.default
    signal-desktop
    sqlite
    swaybg
    trace-cmd
    vial
    vlc
    websocat
    wlr-randr
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
