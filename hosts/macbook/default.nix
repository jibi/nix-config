{ config, pkgs, ... }:

{
  imports = [
    ../default.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "macbook";

  boot.kernelParams = [
    "consoleblank=300"
    "acpi_backlight=vendor"
  ];

  environment.systemPackages = with pkgs; [
    git
    lm_sensors
    screen
  ];

  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      ClientAliveInterval = 60;
      ClientAliveCountMax = 3;
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "ignore";
  };

  services = {
    bisca = {
      enable = true;
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
