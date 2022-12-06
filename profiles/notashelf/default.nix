{
  pkgs,
  config,
  lib,
  ...
}: {
  config.home = {
    stateVersion = "22.11";
    extraOutputsToInstall = ["doc" "devdoc"];
  };

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
