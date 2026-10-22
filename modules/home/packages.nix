{
  config,
  pkgs,
  llm-agents,
  ...
}:

let
  llmAgentsPkgs = llm-agents.packages.${pkgs.stdenv.hostPlatform.system};

  crosspointZip = pkgs.fetchurl {
    url = "https://github.com/crosspoint-reader/calibre-plugins/releases/download/v0.2.8/crosspoint_reader-v0.2.8.zip";
    hash = "sha256-r2qva/5D8zpMY8PcNbZhRaFfA6QGjpV+75RTeQOmzbE=";
  };
  crosspointPlugin = pkgs.runCommand "calibre-crosspoint-reader-0.2.8" { } ''
    mkdir -p "$out"
    ln -s ${crosspointZip} "$out/CrossPoint Reader.zip"
  '';
in
{
  home.packages = with pkgs; [
    acpi
    adwaita-icon-theme
    appimage-run
    audacity
    brightnessctl
    btrfs-progs
    bubblewrap
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

  programs.calibre = {
    enable = true;
    plugins = [ crosspointPlugin ];
  };

  xdg.configFile."calibre/customize.py.json".text = builtins.toJSON {
    plugins."CrossPoint Reader" = "${config.xdg.configHome}/calibre/plugins/CrossPoint Reader.zip";
  };

}
