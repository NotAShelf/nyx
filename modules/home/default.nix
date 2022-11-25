{
  inputs,
  pkgs,
  config,
  lib,
  self,
  ...
}: {
  imports = [
    ./packages.nix

    # HM Modules grouped by topic
    ./graphical
    ./terminal
    ./gaming # proton, lutris, steam, etc
  ];

  home = {
    username = "notashelf";
    stateVersion = "22.11";
    homeDirectory = "/home/notashelf";
    extraOutputsToInstall = ["doc" "devdoc"];
  };

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;
}
