{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) raw package nullOr str;
  cfg = config.services.onedev;

  onedev-package = pkgs.fetchurl {
    url = "https://code.onedev.io/~downloads/projects/160/builds/3835/artifacts/onedev-8.4.2.tar.gz";
    sha256 = "01spl71zdl0ywh5hf83p5d2pxqb9zqhi0akijxv04j3jzkgv2dm6";
  };
in {
  options = {
    services.onedev = {
      enable = mkEnableOption "Onedev server";
      package = mkOption {
        default = onedev-package;
        type = raw;
      };

      javaPackage = mkOption {
        default = pkgs.jdk11_headless;
        type = package;
      };

      user = mkOption {
        default = "onedev";
        type = nullOr str;
      };
    };
  };

  config = let
    user =
      if cfg.user == null
      then "onedev"
      else "${cfg.user}";
  in
    mkIf cfg.enable {
      systemd.user.services."onedev-agent-${toString user}" = {
        enable = true;
        unitConfig = {
          ConditionUser = "${toString user}";
        };
        wantedBy = ["default.target"];
        after = ["network.target"];
        description = "onedev-agent-${toString user}";
        path = [config.system.path];
        serviceConfig = let
          java = "${lib.getExe cfg.javaPackage}";
        in {
          ExecStart = "${java} -cp '${cfg.package}/lib/1.8.21/*' io.onedev.agent.Agent";
          Type = "simple";
        };
      };
    };
}
