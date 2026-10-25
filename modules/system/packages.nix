{
  config,
  lib,
  pkgs,
  ...
}:
let
  isDesktop = config.myconfig.desktop.enable;
in
{
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
      usbutils
      unzip
      zsh
      ghostty.terminfo
    ])
    ++ lib.optionals isDesktop (
      with pkgs;
      [
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
  };

  virtualisation = lib.mkIf config.myconfig.virtualisation.enable {
    docker.enable = true;
    libvirtd = {
      enable = true;
      qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
    };
  };

  services = {
    checklist.enable = isDesktop;
    usbmuxd.enable = isDesktop;
    fwupd.enable = isDesktop;
    pcscd.enable = true;
  };
}
