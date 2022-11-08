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
    ./packages.nix
  ];

  home = {
    username = "notashelf";
    stateVersion = "22.11";
    homeDirectory = "/home/notashelf";
    extraOutputsToInstall = ["doc" "devdoc"];
  };

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;
}
