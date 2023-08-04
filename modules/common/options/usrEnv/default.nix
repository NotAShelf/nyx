{lib, ...}:
with lib; {
  options.modules.usrEnv = {
    # this option will determine what window manager/compositor/desktop environment
    # the system will use
    # TODO: make this a list
    desktop = mkOption {
      type = types.enum ["Hyprland" "sway" "awesome" "i3"];
      default = "Hyprland";
    };

    # should wayland module be loaded? this will include:
    # wayland compatibility options, wayland-only services and programs
    # and the wayland nixpkgs overlay
    isWayland = mkOption {
      type = types.bool;
      default = true;
    };

    autologin = mkOption {
      type = types.bool;
      default = false;
    };

    # should home manager be enabled
    # you MUST to set a username if you want to use home-manager
    useHomeManager = mkOption {
      type = types.bool;
      default = true;
    };
  };
}
