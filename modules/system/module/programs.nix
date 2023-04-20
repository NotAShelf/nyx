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
      enable = mkEnableOption "Enable CLI programs";
    };
    gui = {
      enable = mkEnableOption "Enable GUI programs";
    };

    gaming = {
      enable = mkEnableOption "Enable packages required for the device to be gaming-ready";

      chess = mkOption {
        type = types.bool;
        default = true;
        description = "Chess programs and engines";
      };

      gamescope = mkOption {
        type = types.bool;
        default = true;
        description = "Gamescope";
      };
    };

    git = {
      signingKey = mkOption {
        type = types.str;
        default = "";
        description = "The default gpg key used for signing commits";
      };
    };

    # default program options
    default = {
      # what program should be used as the default terminal
      # do note this is NOT the command, but just the name. i.e setting footclient will
      # not work because the program name will be references as "foot" in the rest of the config
      terminal = mkOption {
        type = types.enum ["foot" "kitty" "wezterm"];
        default = "foot";
      };

      fileManager = mkOption {
        type = types.enum ["thunar" "dolphin" "nemo"];
        default = "thunar";
      };

      browser = mkOption {
        type = types.enum ["firefox" "librewolf" "chromium"];
        default = "firefox";
      };

      editor = mkOption {
        type = types.enum ["neovim" "helix" "emacs"];
        default = "nvim";
      };
    };

    override = {
      # TODO: individual overrides to disable programs enabled by device.type opt
      program = {
        # an example override for the libreoffice program
        # if set to true, libreoffice module will not be enabled

        libreoffice = mkOption {
          type = types.bool;
          default = false;
        };

        /*
           FIXME: proof of concept
        "*" = {
          disable = mkOption {
            type = types.bool;
            description = "Forcefully disables any program that has been overriden to be disabled.";
          };

          enable = mkOption {
            type = types.bool;
            description = "Forcefully enables any program that has been overriden to be enabled.";
          };
        };
        */
      };
      service = {
        /*
        TODO: Override option for services
        */
      };
    };
  };
}
