{osConfig, ...}: let
  inherit (osConfig) modules;

  # theming
  inherit (modules.style) colorScheme;
  inherit (colorScheme) colors;
in {
  wayland.windowManager.hyprland.settings = {
    general = {
      # sensitivity of the mouse cursor
      sensitivity = 0.8;

      # gaps
      gaps_in = 4;
      gaps_out = 8;

      # border thiccness
      border_size = 2;

      # active border color
      "col.active_border" = "0xff${colors.base07}";

      # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
      apply_sens_to_raw = 0;
    };
  };
}
