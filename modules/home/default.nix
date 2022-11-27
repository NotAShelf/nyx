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
  config.home.stateVersion = "22.05";
  imports = [
    ./packages.nix

    ./graphical
    ./terminal
    ./gaming
  ];
  config.modules = {
    programs = {
      vimuwu.enable = true;
      schizofox = {
        enable = true;
        translate = {
          enable = true;
          sourceLang = "en";
          targetLang = "tr";
        };
      };
    };
  };
}
