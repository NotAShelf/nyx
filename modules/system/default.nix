{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ./video
    ./sound
    ./hardware
    ./fs
    ./type
    ./display
  ];
  # Options below NEED to be set on each host
  # or you won't have any drivers/services/programs
  # also your build will fail but that's not important
  # "lmao"
  options.modules.device = {
    # the type of the device
    # laptop and desktop include mostly common modules, but laptop has battery
    # optimizations on top of common programs
    # server has services I would want on a server, and lite is for low-end devices
    # that need only the basics
    # hybrid is for desktops that are also servers (homelabs, basically)
    type = mkOption {
      type = types.enum ["laptop" "desktop" "server" "hybrid" "lite"];
    };

    cpu = mkOption {
      type = types.enum ["intel" "vm-intel" "amd" "vm-amd"];
    };

    # the manifacturer of the system gpu
    # FIXME nvidia and nvidia hybrid currently break on wayland due to
    # broken nvidia drivers
    # remember to set this value, or you will not have any graphics drivers
    gpu = mkOption {
      type = types.enum ["none" "amd" "intel" "nvidia" "hybrid-nv" "hybrid-amd"];
    };

    # this does not affect any drivers and such, it is only necessary for
    # declaring things like monitors in window manager configurations
    monitors = mkOption {
      type = types.listOf types.string;
      default = [];
    };

    # whether the system has bluetooth support
    # can be disabled too
    hasBluetooth = mkOption {
      type = types.bool;
    };

    # whether the system has sound support (usually true except for servers)
    hasSound = mkOption {
      type = types.bool;
    };

    # whether the system has tpm support - win11 style
    hasTPM = mkOption {
      type = types.bool;
      default = false;
    };
  };

  options.modules.system = {
    # do you want wayland module to be loaded? this will include:
    # wayland compatibility options, wayland-only services and programs
    # and the wayland nixpkgs overlay
    isWayland = mkOption {
      # TODO: move to options.modules.environment
      type = types.bool;
      default = true;
    };

    # a list of filesystems available on the system
    # it will enable services based on what strings are found in the list
    fs = mkOption {
      type = types.listOf types.string;
      default = ["vfat" "btrfs" "ext4"]; # TODO: zfs
    };

    # the default user (not users) you plan to use on a specific device
    # this will dictate the initial home-manager settings if home-manager is
    # enabled in usrenv
    username = mkOption {
      type = types.str;
    };

    # TODO: make selected window manager a possible config setting
  };

  options.modules.usrEnv = {
    # TODO: move isWayland in usrEnv
    isWayland = mkOption {
      type = types.bool;
      default = true;
    };

    desktop = mkOption {
      type = types.enum ["hyprland"];
      default = "hyprland";
    };
  };
}
