{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config) modules;
  env = modules.usrEnv;

  cfg = env.brightness;
in {
  config = mkIf cfg.enable {
    systemd.services."system-brightnessd" = {
      description = "Automatic backlight management with systemd";
      wantedBy = ["default.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "${cfg.serviceType}";
        ExecStart = "${lib.getExe cfg.package}";
        Restart = "never";
        RestartSec = "5s";
      };
    };
  };
}
