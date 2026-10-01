{
  pkgs,
  llm-agents,
  ...
}:

let
  llmAgentsPkgs = llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages = with pkgs; [
    acpi
    adwaita-icon-theme
    appimage-run
    audacity
    brightnessctl
    btrfs-progs
    linuxPackages.cpupower
    llmAgentsPkgs.codex
    diceware
    difftastic
    discord
    dnsutils
    eog
    evince
    ffmpeg
    firefox
    gedit
    gimp
    google-chrome
    gparted
    imagemagick
    jujutsu
    libmtp
    libreoffice
    marp-cli
    mgba
    nautilus
    networkmanagerapplet
    nixos-anywhere
    llmAgentsPkgs.opencode
    pass
    pavucontrol
    pulseaudio
    qpdf
    ruby
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
