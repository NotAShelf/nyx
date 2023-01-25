{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.usrEnv = {
    # do you want wayland module to be loaded? this will include:
    # wayland compatibility options, wayland-only services and programs
    # and the wayland nixpkgs overlay
    isWayland = mkOption {
      type = types.bool;
      default = true;
    };

    # this option will determine what window manager/compositor/desktop manager
    # your system will use - my default is Hyprland, Wayland.
    # TODO: make this a list
    desktop = mkOption {
      type = types.enum ["hyprland" "awesome"];
      default = "";
    };

    # should home manager be enabled
    # you NEED to set a username if you want to use home-manager
    useHomeManager = mkOption {
      type = types.bool;
      default = false;
    };
  };
}
