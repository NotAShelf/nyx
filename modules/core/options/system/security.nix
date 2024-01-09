{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkOption mkEnableOption types;
in {
  options.modules.system.security = {
    fixWebcam = mkEnableOption "the purposefully disabled webcam by un-blacklisting the related kernel module.";
    fprint.enable = mkEnableOption "Fingerprint reader service";
    tor.enable = mkEnableOption "Tor daemon";
    usbguard.enable = mkEnableOption "USBGuard service for blocking unauthorized USB devices";
    lockModules = mkEnableOption ''
      kernel module locking to prevent kernel modules that are not specified in the config from being loaded

      This is a highly breaking option, and will break many things including virtualization
      and firewall if the required modules are not explicitly loaded in your kernel configuration.
    '';

    mitigations = {
      disable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = ''
          Whether to disable spectre and meltdown mitigations in the kernel. This is rather a sandbox
          option than something you should consider on a production/mission critical system. Unless
          you know what *exactly* you are doing, do not enable this.
        '';
      };

      acceptRisk = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = ''
          You are either really stupid, or very knowledable. In either case,
          this must be explicitly true in order to ensure users know what they are doing
          when they disable security mitigations.
        '';
      };
    };

    selinux = {
      enable = mkEnableOption "system SELinux support + kernel patches";
      state = mkOption {
        type = with types; enum ["enforcing" "permissive" "disabled"];
        default = "enforcing";
        description = ''
          SELinux state to boot with. The default is enforcing.
        '';
      };

      type = mkOption {
        type = with types; enum ["targeted" "minimum" "mls"];
        default = "targeted";
        description = ''
          SELinux policy type to boot with. The default is targeted.
        '';
      };
    };

    auditd = {
      enable = mkEnableOption "the audit daemon.";
      autoPrune = {
        enable = mkEnableOption "auto-pruning of old audit logs.";

        size = mkOption {
          type = types.int;
          default = 524288000; # roughly 500 megabytes
          description = "The maximum size of the audit log in bytes. The default is 500MBs";
        };

        dates = mkOption {
          type = types.str;
          default = "daily";
          example = "weekly";
          description = "How often cleaning is triggered. Passed to systemd.time";
        };
      };
    };

    clamav = {
      enable = mkEnableOption "ClamAV daemon.";
      daemon = {
        settings = mkOption {
          type = with types; attrsOf (oneOf [bool int str (listOf str)]);
          default = {
            LogFile = "/var/log/clamd.log";
            LogTime = true;
            DetectPUA = true;
            VirusEvent = lib.escapeShellArgs [
              "${pkgs.libnotify}/bin/notify-send"
              "--"
              "ClamAV Virus Scan"
              "Found virus: %v"
            ];
          };

          description = ''
            ClamAV configuration. Refer to <https://linux.die.net/man/5/clamd.conf>,
            for details on supported values.
          '';
        };
      };

      updater = {
        enable = mkEnableOption "ClamAV freshclam updater";

        frequency = mkOption {
          type = types.int;
          default = 12;
          description = ''
            Number of database checks per day.
          '';
        };

        interval = mkOption {
          type = types.str;
          default = "hourly";
          description = ''
            How often freshclam is invoked. See systemd.time(7) for more
            information about the format.
          '';
        };

        settings = mkOption {
          type = with types; attrsOf (oneOf [bool int str (listOf str)]);
          default = {};
          description = ''
            freshclam configuration. Refer to <https://linux.die.net/man/5/freshclam.conf>,
            for details on supported values.
          '';
        };
      };
    };
  };
}
