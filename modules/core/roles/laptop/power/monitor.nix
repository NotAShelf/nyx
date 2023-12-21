{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  # script courtesy of Fufexan
  script = pkgs.writeShellScript "power_monitor.sh" builtins.readFile ./power_monitor.sh;
  dependencies = with pkgs; [
    coreutils
    power-profiles-daemon
    inotify-tools
  ];

  dev = config.modules.device;
  acceptedTypes = ["laptop" "hybrid"];
in {
  config = mkIf (builtins.elem dev.types acceptedTypes) {
    # Power state monitor. Switches Power profiles based on charging state.
    # Plugged in - performance
    # Unplugged - power-saver
    systemd.user.services.power-monitor = {
      Unit.Description = "Power Monitor";
      Service = {
        Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
        Type = "simple";
        ExecStart = script;
        Restart = "on-failure";
      };
      Install = {
        After = ["power-profiles-daemon.service"];
        WantedBy = ["default.target"];
      };
    };
  };
}
