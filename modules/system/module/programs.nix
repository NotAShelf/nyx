{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  # this module provides overrides for certain defaults and lets you set
  # default programs for referencing in other config files.
  options.modules.programs = {
    # TODO: turn those into overrides
    # load GUI and CLI programs by default, but check if those overrides are enabled
    # so that they can be disabled at will
    cli = {
      enabled = mkEnableOption "cli";
    };
    gui = {
      enabled = mkEnableOption "gui";
    };

    gaming = {
      enable = mkEnableOption "gaming";

      chess = mkOption {
        type = types.bool;
        default = true;
      };

      # TODO: gamescope option
    };

    # default program options
    default = {
      # what program should be used as the default terminal
      # do note this is NOT the command, just the name. i.e setting footclient will
      # not work.
      terminal = mkOption {
        type = types.enum ["foot" "kitty" "wezterm"];
        default = "foot";
      };

      # TODO: browser, file manager, editor etc.
    };

    overrides = {
      # TODO: individual overrides to disable programs enabled by device.type opt
    };
  };
}
