{
  lib,
  pkgs,
  ...
}: {
  boot.plymouth = let
    pack = 3;
    theme = "hud_3";
  in {
    enable = true;
    #themePackages = [
    #  (pkgs.plymouth-themes.override {inherit pack theme;})
    #];
    #inherit theme;
  };
}
