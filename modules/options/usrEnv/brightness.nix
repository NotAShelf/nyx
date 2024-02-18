{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkOption;
  inherit (lib.types) ints bool enum package;

  cfg = config.modules.usrEnv.brightness;
in {
  options.modules.usrEnv.brightness = {
    enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable brightness management with systemd.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.writeShellApplication {
        name = "set-system-brightness";
        runtimeInputs = with pkgs; [brightnessctl];
        text = "brightnessctl set ${cfg.value}";
      };
    };

    value = mkOption {
      type = ints.between 0 100;
      default = 85; # try to save some battery on laptops
      description = ''
        The screen brightness that will be set once the graphical target is reached.
      '';
    };

    service = {
      type = mkOption {
        type = enum ["oneshot" "simple"];
        default = "oneshot";
        description = ''
          The type of the service to be used for setting brightness on graphical session start.
        '';
      };

      target = mkOption {
        type = enum ["graphical-session.target" "multi-user.target"];
        default = "graphical-session.target";
        description = ''
          The target that the systemd-brightnessd service will be bound to.

          This effectively sets the `after` attribute in the serviceConfig
        '';
      };
    };
  };
}
