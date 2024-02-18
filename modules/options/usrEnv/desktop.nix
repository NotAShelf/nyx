{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkOption types;

  cfg = config.modules.usrEnv;
  sys = config.modules.system;
in {
  options.modules.usrEnv = {
    desktop = mkOption {
      type = types.enum ["none" "Hyprland" "sway" "awesomewm" "i3"];
      default = "none";
      description = ''
        The desktop environment to be used.
      '';
    };

    desktops = {
      hyprland.enable = mkOption {
        type = types.bool;
        default = cfg.desktop == "Hyprland";
        description = ''
          Whether to enable Hyprland wayland compositor.

          Will be enabled automatically when `modules.usrEnv.desktop` is set to "Hyprland".

        '';
      };

      sway.enable = mkOption {
        type = types.bool;
        default = cfg.desktop == "sway";
        description = ''
          Whether to enable Sway wayland compositor.

          Will be enabled automatically when `modules.usrEnv.desktop` is set to "sway".
        '';
      };

      awesomwm.enable = mkOption {
        type = types.bool;
        default = cfg.desktop == "awesomewm";
        description = ''
          Whether to enable Awesome window manager

          Will be enabled automatically when `modules.usrEnv.desktop` is set to "awesomewm".
        '';
      };

      i3.enable = mkOption {
        type = types.bool;
        default = cfg.desktop == "i3";
        description = ''
          Whether to enable i3 window manager

          Will be enabled automatically when `modules.usrEnv.desktop` is set to "i3".
        '';
      };
    };

    useHomeManager = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to enable the usage of home-manager for user home management. Maps the list
        of users to their home directories inside the `homes/` directory in the repository
        root.

        Username via `modules.system.mainUser` must be set if this option is enabled.
      '';
    };
  };

  config = {
    assertions = [
      {
        assertion = cfg.useHomeManager -> sys.mainUser != null;
        message = "modules.system.mainUser must be set while modules.usrEnv.useHomeManager is enabled";
      }
    ];
  };
}
