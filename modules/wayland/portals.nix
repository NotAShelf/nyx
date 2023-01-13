{
  pkgs,
  inputs,
  ...
}: {
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
}
