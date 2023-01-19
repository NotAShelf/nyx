{lib, ...}:
with lib; let
  device = config.modules.device;
  acceptedTypes = ["desktop" "laptop" "hybrid" "lite"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    environment.variables = {
      # open links with the default browser
      BROWSER = "firefox";

      # set GTK theme as specified by the catppuccin-gtk package in 'pkgs'
      GTK_THEME = "Catppuccin-Mocha-Pink";

      # gtk applications should use filepickers specified by xdg
      GTK_USE_PORTAL = "1";
    };
  };
}
