{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;
  inherit (modules.style.colorScheme) colors;

  dev = modules.device;
  acceptedTypes = ["laptop" "desktop" "hybrid"];
in {
  config = mkIf (builtins.elem dev.type acceptedTypes) {
    programs.wezterm = {
      enable = true;
      package = pkgs.wezterm;
      colorSchemes = import ./colorSchemes.nix {inherit colors;};
      extraConfig = ''
        local wez = require("wezterm")

        return {
         -- general
         check_for_updates = false,
         exit_behavior = "CloseOnCleanExit",
         enable_scroll_bar = false,

         -- tab bar
         enable_tab_bar = true,
         use_fancy_tab_bar = false,
         hide_tab_bar_if_only_one_tab = true,
         show_tab_index_in_tab_bar = false,

         -- font config
         font_size = 14.0,
         font = wez.font_with_fallback({
          "Iosevka Nerd Font",
          "Material Design Icons",
         }),

         audible_bell = "Disabled",
         default_cursor_style = "SteadyBar",
         window_background_opacity = 0.85,

         window_padding = {
          left = 16,
          right = 16,
          top = 16,
          bottom = 16,
         },

         -- perf
         front_end = "WebGpu",
         enable_wayland = true,
         scrollback_lines = 1024,

         -- colors
         -- the followSystem theme is defined in colorSchemes.nix
         -- as per my base16 theming options
         color_scheme = "followSystem",

         -- misc
         window_close_confirmation = "NeverPrompt",
         inactive_pane_hsb = {
          saturation = 1.0,
          brightness = 0.8
         },
        }
      '';
    };
  };
}
