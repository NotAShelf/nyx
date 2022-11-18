{
  inputs,
  pkgs,
  config,
  lib,
  self,
  ...
}:
# glue all configs together
{
  imports = [
    ./gtk
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
