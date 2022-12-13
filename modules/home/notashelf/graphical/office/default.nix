{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    libreoffice-qt
    hunspell
    hunspellDicts.uk_UA
  ];
}
