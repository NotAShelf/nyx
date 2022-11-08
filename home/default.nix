{
  inputs,
  pkgs,
  config,
  ...
}:
# glue all configs together
{
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./packages.nix
    ./gtk
    ./kitty
    ./mako
    ./rofi
    ./shell
    ./swaylock
    ./tmux
    ./tools
    ./waybar
    ./zathura
    ./hyprland
  ];
  
  home = {
    username = "notashelf";
    stateVersion = "22.09";
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
