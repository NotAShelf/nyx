{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.system.video;
  env = config.modules.usrEnv;
in {
  config = mkIf (cfg.enable && env.isWayland) {
    xdg.portal = {
      extraPortals = with inputs; [
        #xdg-portal-hyprland.packages.${pkgs.system}.default
      ];
      # xdg-desktop-wlr (this section) is no longer needed, xdg-desktop-portal-hyprland
      # will (and should) override this one, set to false or remove this section
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
