{lib, ...}: let
  inherit (lib) mkOption mkEnableOption mdDoc types;
in {
  options.modules.system.security = {
    fixWebcam = mkEnableOption (mdDoc "Fix the purposefully broken webcam by un-blacklisting the related kernel module.");
    tor.enable = mkEnableOption (mdDoc "Tor daemon");
    lockModules = mkEnableOption (mdDoc ''
      Enable kernel module locking to prevent kernel modules that are not specified in the config from being loaded
    '');

    auditd = {
      enable = mkEnableOption (mdDoc "Enable the audit daemon.");
      autoPrune = {
        enable = mkEnableOption (mdDoc "Enable auto-pruning of audit logs.");

        size = mkOption {
          type = types.int;
          default = 524288000; # roughly 500 megabytes
          description = "The maximum size of the audit log in bytes.";
        };

        dates = mkOption {
          type = types.str;
          default = "daily";
          example = "weekly";
          description = "How often cleaning is triggered. Passed to systemd.time";
        };
      };
    };
  };
}
