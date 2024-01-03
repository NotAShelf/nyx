{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  auditEnabled = sys.security.auditd.enable;
in {
  config = mkIf auditEnabled {
    security = {
      # system audit
      auditd.enable = true;
      audit = {
        enable = true;
        backlogLimit = 8192;
        failureMode = "printk";
        rules = [
          "-a exit,always -F arch=b64 -S execve"
        ];
      };
    };

    systemd = {
      # a systemd timer to clean /var/log/audit.log daily
      # this can probably be weekly, but daily means we get to clean it every 2-3 days instead of once a week
      timers."clean-audit-log" = {
        description = "Periodically clean audit log";
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
        };
      };

      # clean audit log if it's more than 524,288,000 bytes, which is roughly 500 megabytes
      # it can grow MASSIVE in size if left unchecked
      services."clean-audit-log" = {
        script = ''
          set -eu
          if [[ $(stat -c "%s" /var/log/audit/audit.log) -gt 524288000 ]]; then
            echo "Clearing Audit Log";
            rm -rvf /var/log/audit/audit.log;
            echo "Done!"
          fi
        '';

        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };

      # TODO: remove this once nixpkgs#278090 hits nixos-unstable
      services.auditd.conflicts = lib.mkForce ["shutdown.target"];
    };
  };
}
