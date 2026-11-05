{ config, lib, ... }:

let
  cfg = config.modules.fingerprint;
in
{
  options.modules.fingerprint = {
    enable = lib.mkEnableOption "fingerprint authentication";
    todDriver = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = null;
      description = "Optional libfprint TOD driver for the fingerprint reader";
    };
  };

  config = lib.mkIf cfg.enable {
    services.fprintd = {
      enable = true;
      tod = lib.mkIf (cfg.todDriver != null) {
        enable = true;
        driver = cfg.todDriver;
      };
    };

    security.pam.services.waylock = lib.mkIf config.modules.desktop.enable {
      rules.auth.unix.order = config.security.pam.services.waylock.rules.auth.fprintd.order - 1;
    };
  };
}
