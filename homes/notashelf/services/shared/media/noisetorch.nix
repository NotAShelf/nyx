{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption literalExpression types;

  cfg = config.services.noisetorch;

  dev = osConfig.modules.device;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  options = {
    services.noisetorch = {
      enable = mkEnableOption "noisetorch service";
      package = mkOption {
        type = types.package;
        default = pkgs.noisetorch;
        defaultText = literalExpression "pkgs.noisetorch";
        description = "Which package to use for noisetorch";
      };
      threshold = mkOption {
        type = types.int;
        default = -1;
        description = "Voice activation threshold (default -1)";
      };
      device = mkOption {
        type = types.str;
        description = "Use the specified source/sink device ID";
      };
      deviceUnit = mkOption {
        type = types.str;
        description = "Systemd device unit which is providing the audio device";
      };
    };
  };

  config = mkIf (cfg.enable && builtins.elem dev.type acceptedTypes) {
    home.packages = [cfg.package];

    systemd.user.services.noisetorch = {
      Unit = {
        Description = "Noisetorch Noise Cancelling";
        Requires = "${cfg.deviceUnit}";
        After = "${cfg.deviceUnit}";
      };
      Install = {
        WantedBy = ["default.target"];
      };
      Service = {
        Type = "simple";
        RemainAfterExit = "yes";
        ExecStart = "${cfg.package}/bin/noisetorch -i -s ${cfg.device} -t ${builtins.toString cfg.threshold}";
        ExecStop = "${cfg.package}/bin/noisetorch -u";
        Restart = "on-failure";
        RestartSec = 3;
        Nice = -10;
      };
    };
  };
}
