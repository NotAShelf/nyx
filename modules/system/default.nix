{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
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
    type = mkOption {
      type = types.enum ["laptop" "desktop" "server" "lite"];
    };

    cpu = mkOption {
      type = types.enum ["intel" "vm-intel" "amd" "vm-amd"];
    };

    # the manifacturer of the system gpu
    # FIXME nvidia hybrid currently breaks wayland due to broken nvidia drivers
    # remember to set this value, or you will not have any graphics drivers
    gpu = mkOption {
      type = types.enum ["amd" "intel" "nvidia" "vm" "nvHybrid" "amdHybrid"];
    };

    # this does not affect any drivers and such, it is only necessary for
    # declaring things like monitors in window manager configurations
    monitors = mkOption {
      type = types.listOf types.str;
      default = [];
    };

    # whether the system has bluetooth support
    # can be disabled to
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

    # do you want wayland module to be loaded? this will include:
    # wayland compatibility options, wayland-only services and programs
    isWayland = mkOption {
      type = types.bool;
      default = true;
    };

    # TODO: make selected window manager a possible config setting
  };
}
