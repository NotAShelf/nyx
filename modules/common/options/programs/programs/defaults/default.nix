{lib, ...}: let
  inherit (lib) types mkOption;
in {
  options.modules.programs = {
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
}
