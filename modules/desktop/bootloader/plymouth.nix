{
  config,
  lib,
  pkgs,
  ...
}: {
  # enable plymouth with default theme
  boot.plymouth.enable = true;

  # make plymouth work with sleep
  powerManagement.powerDownCommands = ''
    ${pkgs.plymouth} --show-splash
  '';
  powerManagement.resumeCommands = ''
    ${pkgs.plymouth} --quit
  '';

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
