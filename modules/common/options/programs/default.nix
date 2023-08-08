{
  config,
  lib,
  ...
}:
with lib; {
  imports = [./overrides.nix];
  # this module provides overrides for certain defaults and lets you set
  # default programs for referencing in other config files.
  options.modules = {
    programs = {
      cli = {
        enable = mkEnableOption "Enable CLI programs";
      };
      gui = {
        enable = mkEnableOption "Enable GUI programs";
      };

      gaming = {
        enable = mkEnableOption "Enable packages required for the device to be gaming-ready";

        emulation.enable = mkEnableOption "Enable programs required to emulate other platforms";

        chess.enable = mkEnableOption "Chess programs and engines";

        gamescope.enable = mkEnableOption "Gamescope compositing manager" // {default = config.modules.programs.gaming.enable;};
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
          default = "kitty";
        };

        fileManager = mkOption {
          type = types.enum ["thunar" "dolphin" "nemo"];
          default = "dolphin";
        };

        browser = mkOption {
          type = types.enum ["firefox" "librewolf" "chromium"];
          default = "firefox";
        };

        editor = mkOption {
          type = types.enum ["neovim" "helix" "emacs"];
          default = "neovim";
        };

        launcher = mkOption {
          type = types.enum ["rofi" "wofi" "anyrun"];
          default = "rofi";
        };
      };
    };
  };
}
