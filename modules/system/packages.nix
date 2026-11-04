{
  config,
  lib,
  pkgs,
  ...
}:
let
  isDesktop = config.myconfig.desktop.enable;

  # see NixOS/nixpkgs#580890
  appimageToolsOverlay = final: prev: {
    appimageTools = prev.appimageTools.override {
      buildFHSEnv = final.lib.extendMkDerivation {
        constructDrv = final.buildFHSEnv;
        extendDrvArgs = _: args: {
          targetPkgs = pkgs: args.targetPkgs pkgs ++ [ pkgs.libgpg-error ];
        };
      };
    };
  };
in
{
  nixpkgs = {
    config.allowUnfree = true;

    overlays = [
      appimageToolsOverlay
    ];
  };

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
