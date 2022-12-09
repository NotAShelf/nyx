{
  config,
  lib,
  pkgs,
  ...
}: {
  boot.plymouth.enable = true;

  # configure plymouth theme
  # <https://github.com/adi1090x/plymouth-themes>
  #boot.plymouth = let
  #  pack = 3;
  #  theme = "hud_3";
  #in {
  #  enable = true;
  #  themePackages = [
  #    (pkgs.nixos-plymouth.override {inherit pack theme;})
  #  ];
  #  inherit theme;
  #};
}
