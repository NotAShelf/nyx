{
  inputs,
  pkgs,
  config,
  ...
}:
# glue all configs together
{
  imports = [
    ./graphical
    ./terminal
    ./office
    ./gaming
    ./packages.nix
  ];

  home = {
    username = "notashelf";
    stateVersion = "22.11";
    homeDirectory = "/home/notashelf";
    extraOutputsToInstall = ["doc" "devdoc"];
  };

  # let HM manage itself when in standalone mode
  #programs.home-manager.enable = true;
}
