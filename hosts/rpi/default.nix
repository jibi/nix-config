{
  config,
  bisca,
  lib,
  pkgs,
  nixpkgs-rpi-kernel,
  ...
}:

let
  buildSystem = pkgs.stdenv.buildPlatform.system;
  system = pkgs.stdenv.hostPlatform.system;

  crossPkgs = import bisca.inputs.nixpkgs {
    localSystem = buildSystem;
    crossSystem = system;
    overlays = [ bisca.overlays.default ];
  };

  rpiPkgs = nixpkgs-rpi-kernel.legacyPackages.${system};
in
{
  imports = [
    ../default.nix
    ./sd-image.nix
    ./wireguard.nix
  ];

  nix.settings.trusted-users = [ "jibi" ];

  boot = {
    kernelPackages = lib.mkForce rpiPkgs.linuxPackages_rpi02w;
    initrd.systemd.tpm2.enable = false;
    initrd.availableKernelModules = lib.mkMerge [
      [
        "xhci_pci"
        "usbhid"
        "usb_storage"
      ]
      {
        # todo: remove this when this is fixed: https://github.com/NixOS/nixpkgs/issues/154163
        dw-hdmi = lib.mkForce false;
        dw-mipi-dsi = lib.mkForce false;
        rockchipdrm = lib.mkForce false;
        rockchip-rga = lib.mkForce false;
        phy-rockchip-pcie = lib.mkForce false;
        pcie-rockchip-host = lib.mkForce false;
        pwm-sun4i = lib.mkForce false;
        sun4i-drm = lib.mkForce false;
        sun8i-mixer = lib.mkForce false;
      }
    ];

    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };

    swraid.enable = lib.mkForce false;
    supportedFilesystems.zfs = lib.mkForce false;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  hardware = {
    enableRedistributableFirmware = lib.mkForce false;
    firmware = [ pkgs.raspberrypiWirelessFirmware ];
    deviceTree = {
      enable = true;
      filter = "*2837*";
    };
  };

  myconfig.wifi.backend = "wpa_supplicant";

  networking = {
    firewall.allowedTCPPorts = [
      80
      443
    ];
    hostName = "rpi";
    wireless.interfaces = [ "wlan0" ];
  };

  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };

    bisca = {
      enable = true;
      backend.package = crossPkgs.bisca-backend;
    };

    umami = {
      enable = true;
      settings.PORT = 3001;
      settings.APP_SECRET_FILE = config.age.secrets.umami-secret.path;
    };

    caddy.virtualHosts."stats.jibi.io" = {
      extraConfig = ''
        reverse_proxy localhost:3001
      '';
    };
  };

  system.stateVersion = "25.11";
}
