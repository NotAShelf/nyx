{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

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
          "-a exit,always -F arch=b64 -F euid=0 -S execve"
          "-a exit,always -F arch=b32 -F euid=0 -S execve"
          "-a exit,always -F arch=b64 -F euid=0 -S execveat"
          "-a exit,always -F arch=b32 -F euid=0 -S execveat"

          # Protect logfile
          "-w /var/log/audit/ -k auditlog"

          # Log program executions
          "-a exit,always -F arch=b64 -S execve -F key=progexec"

          # Home path access/modification
          "-a always,exit -F arch=b64 -F dir=/home -F perm=war -F key=homeaccess"

          # Kexec attempts
          "-a always,exit -F arch=b64 -S kexec_load -F key=KEXEC"
          "-a always,exit -F arch=b32 -S sys_kexec_load -k KEXEC"

          # Unauthorized file access
          "-a always,exit -F arch=b64 -S open,creat -F exit=-EACCES -k access"
          "-a always,exit -F arch=b64 -S open,creat -F exit=-EPERM -k access"
          "-a always,exit -F arch=b32 -S open,creat -F exit=-EACCES -k access"
          "-a always,exit -F arch=b32 -S open,creat -F exit=-EPERM -k access"
          "-a always,exit -F arch=b64 -S openat -F exit=-EACCES -k access"
          "-a always,exit -F arch=b64 -S openat -F exit=-EPERM -k access"
          "-a always,exit -F arch=b32 -S openat -F exit=-EACCES -k access"
          "-a always,exit -F arch=b32 -S openat -F exit=-EPERM -k access"
          "-a always,exit -F arch=b64 -S open_by_handle_at -F exit=-EACCES -k access"
          "-a always,exit -F arch=b64 -S open_by_handle_at -F exit=-EPERM -k access"
          "-a always,exit -F arch=b32 -S open_by_handle_at -F exit=-EACCES -k access"
          "-a always,exit -F arch=b32 -S open_by_handle_at -F exit=-EPERM -k access"

          # Failed modification of important mountpoints or files
          "-a always,exit -F arch=b64 -S open -F dir=/etc -F success=0 -F key=unauthedfileaccess"
          "-a always,exit -F arch=b64 -S open -F dir=/bin -F success=0 -F key=unauthedfileaccess"
          "-a always,exit -F arch=b64 -S open -F dir=/var -F success=0 -F key=unauthedfileaccess"
          "-a always,exit -F arch=b64 -S open -F dir=/home -F success=0 -F key=unauthedfileaccess"
          "-a always,exit -F arch=b64 -S open -F dir=/srv -F success=0 -F key=unauthedfileaccess"
          "-a always,exit -F arch=b64 -S open -F dir=/boot -F success=0 -F key=unauthedfileaccess"
          "-a always,exit -F arch=b64 -S open -F dir=/nix -F success=0 -F key=unauthedfileaccess"

          # File deletions by system users
          "-a always,exit -F arch=b64 -S rmdir -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=-1 -F key=delete"

          # Root command executions
          "-a always,exit -F arch=b64 -F euid=0 -F auid>=1000 -F auid!=-1 -S execve -F key=rootcmd"

          # Shared memory access
          "-a exit,never -F arch=b32 -F dir=/dev/shm -k sharedmemaccess"
          "-a exit,never -F arch=b64 -F dir=/dev/shm -k sharedmemaccess"
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
    };
  };
}
