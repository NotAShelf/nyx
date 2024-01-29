{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkForce;

  dependencies = with pkgs; [
    coreutils
    power-profiles-daemon
    inotify-tools
  ];
in {
  config = {
    # Power state monitor. Switches Power profiles based on charging state.
    # Plugged in - performance
    # Unplugged - power-saver
    systemd.user.services."power-monitor" = {
      description = "Power Monitoring Service";
      environment.PATH = mkForce "/run/wrappers/bin:${lib.makeBinPath dependencies}";
      script = builtins.readFile ./scripts/power_monitor.sh;

      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
      };

      wants = ["power-profiles-daemon.service"];
      wantedBy = ["default.target"];
    };
  };
}
