{
  inputs,
  pkgs,
  config,
  lib,
  self,
  ...
}: {
  imports = [
    ./gtk
    ./hyprland
    ./mako
    ./rofi
    ./swaylock
    ./waybar
    ./firefox
    ./zathura
    ./office
    inputs.hyprland.homeManagerModules.default
  ];

  modules = {
    programs = {
      schizofox = {
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
