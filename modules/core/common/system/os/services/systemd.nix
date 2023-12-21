{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf optionalAttrs;

  dev = config.modules.device;
in {
  # https://wiki.archlinux.org/title/Systemd/Journal#Persistent_journals
  # limit systemd journal size
  # journals get big really fasti and on desktops they are not audited often
  # on servers, however, they are important for both security and stability
  # thus, persisting them as is remains a good idea
  services.journald.extraConfig = mkIf (dev.type != "server") ''
    SystemMaxUse=100M
    RuntimeMaxUse=50M
    SystemMaxFileSize=50M
  '';

  systemd =
    {
      # Systemd OOMd
      # Fedora enables these options by default. See the 10-oomd-* files here:
      # https://src.fedoraproject.org/rpms/systemd/tree/acb90c49c42276b06375a66c73673ac3510255
      oomd = {
        enableRootSlice = true;
        enableUserServices = true;
        enableSystemSlice = true;
      };

      tmpfiles.rules = [
        # Enables storing of the kernel log (including stack trace) into pstore upon a panic or crash.
        "w /sys/module/kernel/parameters/crash_kexec_post_notifiers - - - - Y"
        # Enables storing of the kernel log upon a normal shutdown (shutdown, reboot, halt).
        "w /sys/module/printk/parameters/always_kmsg_dump - - - - N"
      ];
    }
    // optionalAttrs config.security.auditd.enable {
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
    };
}
