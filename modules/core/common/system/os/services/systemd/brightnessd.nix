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

      # TODO: maybe this needs to be a part of graphical-session.target?
      # I am not very sure how wantedBy and partOf really work
      wantedBy = ["default.target"];
      partOf = ["graphical-session.target"];

      # TODO: this needs to be hardened
      # not that a backlight service is a security risk, but it's a good habit
      # to keep our systemd services as secure as possible
      serviceConfig = {
        Type = "${cfg.serviceType}";
        ExecStart = "${lib.getExe cfg.package}";
        Restart = "never";
        RestartSec = "5s";
      };
    };
  };
}
