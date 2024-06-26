{
  inputs',
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) readFile;
  inherit (lib.modules) mkForce;
  inherit (lib.strings) makeBinPath;

  dependencies = with pkgs;
    [
      coreutils
      power-profiles-daemon
      inotify-tools
      jaq
    ]
    ++ [
      inputs'.hyprland.packages.hyprland
    ];
in {
  config = {
    # Allows changing system behavior based upon user-selected power profiles.
    # The project seems to be archived, and the GitLab page seems to be down
    # more often than it is up. We may consider removing it but lets keep it
    # for documentation. Power management should be handled by auto-cpufreq
    # instead, since it is more actively maintained.
    services.power-profiles-daemon.enable = false;

    # Power state monitor. Switches Power profiles based on charging state.
    # Plugged in - performance
    # Unplugged - power-saver
    systemd.services."power-monitor" = {
      description = "Power Monitoring Service";
      environment.PATH = mkForce "/run/wrappers/bin:${makeBinPath dependencies}";
      script = readFile ./scripts/power_monitor.sh;

      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
      };

      wants = ["power-profiles-daemon.service"];
      wantedBy = ["default.target"];
    };
  };
}
