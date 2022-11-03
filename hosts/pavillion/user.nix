{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [../../modules/default.nix ../../home];
  config.modules = {
    desktop.hyprland.enable = true;
    programs = {
      btm.enable = true;
      neofetch.enable = true;
      schizofox = {
        enable = true;
        translate = {
          enable = true;
          sourceLang = "en";
          targetLang = "tr";
        };
      };
      vimuwu.enable = true;
    };
  };
}
