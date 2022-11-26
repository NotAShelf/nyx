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
  config.home = {
    username = "notashelf";
    stateVersion = "22.11";
    homeDirectory = "/home/notashelf";
    extraOutputsToInstall = ["doc" "devdoc"];
  };
  imports = [
    ./packages.nix

    # HM Modules grouped by topic
    ./graphical
    ./terminal
    #./gaming # proton, lutris, steam, etc
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
      vimuwu.enable = true;
    };
  };
}
