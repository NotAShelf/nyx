{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf mkForce;

  sys = config.modules.system;
  security = sys.security;
in {
  config = mkIf sys.security.clamav.enable {
    environment.systemPackages = [pkgs.clamav];

    services.clamav = {
      daemon = {enable = true;} // security.clamav.daemon;
      updater = {enable = true;} // security.clamav.updater;
    };

    systemd = {
      tmpfiles.settings."10-clamscan" = {
        "/var/lib/clamav"."D" = {
          group = "clamav";
          user = "clamav";
          mode = "755";
        };
      };

      services = {
        clamav-daemon = {
          serviceConfig = {
            PrivateTmp = mkForce "no";
            PrivateNetwork = mkForce "no";
            Restart = "always";
          };

          unitConfig = {
            # only start clamav when required database files are present
            # especially useful if you are deploying headlessly and don't want a service fail instantly
            ConditionPathExistsGlob = [
              "/var/lib/clamav/main.{c[vl]d,inc}"
              "/var/lib/clamav/daily.{c[vl]d,inc}"
            ];
          };
        };

        clamav-init-database = {
          wantedBy = ["clamav-daemon.service"];
          before = ["clamav-daemon.service"];
          serviceConfig.ExecStart = "systemctl start clamav-freshclam";
          unitConfig = {
            # opposite condition of clamav-daemon: only run this service if
            # database files are not present in the database directory
            ConditionPathExistsGlob = [
              "!/var/lib/clamav/main.{c[vl]d,inc}"
              "!/var/lib/clamav/daily.{c[vl]d,inc}"
            ];
          };
        };

        clamav-freshclam = {
          wants = ["clamav-daemon.service"];
          serviceConfig = {
            ExecStart = let
              message = "Updating ClamAV database";
            in ''
              ${pkgs.coreutils}/bin/echo -en ${message}
            '';
            SuccessExitStatus = mkForce [11 40 50 51 52 53 54 55 56 57 58 59 60 61 62];
          };
        };
      };

      timers.clamav-freshclam.timerConfig = {
        # The default is to run the timer hourly, but we do not want our entire infra to be overloaded
        # trying to run a ClamAV scan simultaneously. So randomize the timer to something around an hour
        # so that the window is consistent, but the load is not.
        RandomizedDelaySec = "60m";
        FixedRandomDelay = true;
        Persistent = true;
      };
    };
  };
}
