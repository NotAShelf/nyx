{
  inputs,
  pkgs,
  config,
  lib,
  self,
  ...
}: {
  imports = [
    #./gtk
    ./hyprland
    ./mako
    ./rofi
    ./swaylock
    ./waybar
    ./firefox
    ./zathura
    ./newsboat
    inputs.hyprland.homeManagerModules.default
  ];

  config.modules = {
    programs = {
      firefox = {
        enable = true;
        translate = {
          enable = true;
          sourceLang = "en";
          targetLang = "pl";
        };
      };
    };
  };
}
