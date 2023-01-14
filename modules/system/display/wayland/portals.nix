{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.system.video;
  sys = config.modules.system;
in {
  config = mkIf (cfg.enable && sys.isWayland) {
    xdg.portal = {
      extraPortals = with inputs; [
        xdg-portal-hyprland.packages.${pkgs.system}.default
      ];
      wlr = {
        enable = false;
        settings = {
          screencast = {
            max_fps = 60;
            chooser_type = "simple";
            chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
          };
        };
      };
    };
  };
}
