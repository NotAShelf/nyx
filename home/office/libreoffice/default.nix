{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: with lib; let
  office = libreoffice-fresh-unwrapped;
in {
  
  environment.sessionVariables = {
    PYTHONPATH = "${office}/lib/libreoffice/program";
    URE_BOOTSTRAP = "vnd.sun.star.pathname:${office}/lib/libreoffice/program/fundamentalrc";
  };
  
  home.packages = with pkgs; [
    libreoffice-qt
    hunspell
    hunspellDicts.uk_UA
    hunspellDicts.th_TH
  ];
}
