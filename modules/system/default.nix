{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ./media
    ./hardware
    ./fs
    ./type
    ./display
  ];
  options.modules.device = {
    # the type of the device
    # laptop and desktop include mostly common modules, but laptop has battery
    # optimizations on top of common programs
    # server has services I would want on a server, and lite is for low-end devices
    # that need only the basics
    # hybrid is for desktops that are also servers (my homelabs, basically)
    type = mkOption {
      type = types.enum ["laptop" "desktop" "server" "hybrid" "lite"];
    };

    # the type of cpu your system has - vm and regular cpus currently do not differ
    # as I do not work with vms, but they have been added for forward-compatibility
    # TODO: make this a list
    cpu = mkOption {
      type = types.enum ["pi" "intel" "vm-intel" "amd" "vm-amd"];
      default = "";
    };

    # the manifacturer/type of the system gpu
    # FIXME nvidia and nvidia hybrid currently break on wayland due to
    # broken nvidia driver - mozilla products and plymouth commit die
    # remember to set this value, or you will not have any graphics drivers
    # TODO: make this a list
    # TODO: raspberry pi specific GPUs
    gpu = mkOption {
      type = types.enum ["pi" "amd" "intel" "nvidia" "hybrid-nv" "hybrid-amd"];
      default = "";
    };

    # this does not affect any drivers and such, it is only necessary for
    # declaring things like monitors in window manager configurations
    # you can avoid declaring this, but I'd rather if you did declare
    monitors = mkOption {
      type = types.listOf types.string;
      default = [];
    };

    # whether the system has bluetooth support
    # bluetooth is an insecure protocol if left unchedked, so while this defaults to true
    # the bluetooth.enable does and should not.
    hasBluetooth = mkOption {
      type = types.bool;
    };

    # whether the system has sound support (usually true except for servers)
    # TODO: hook music tagger programs to the evaluation of this option
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
    # the default user (not users) you plan to use on a specific device
    # this will dictate the initial home-manager settings if home-manager is
    # enabled in usrenv
    username = mkOption {
      type = types.str;
    };

    # no actual use yet, do not use
    # TODO: replace networking.hostname with this value (?)
    hostname = mkOption {
      type = types.str;
    };

    # a list of filesystems available on the system
    # it will enable services based on what strings are found in the list
    fs = mkOption {
      type = types.listOf types.string;
      default = ["vfat" "ext4"]; # TODO: zfs, ntfs
    };

    # should we enable emulation for additional architechtures?
    # enabling this option will make it so that you can build for, e.g.
    # aarch64 on x86_&4 and vice verse - not recommended on weaker machines
    emulation = {
      enable = mkEnableOption "emulation";
    };

    # should the device
    sound = {
      enable = mkEnableOption "sound";
    };

    # should the device enable graphical programs
    # TODO: Is this even necessary? Might need to return to this later.
    # Most graphical apps don't depend on this value and use device type instead
    video = {
      enable = mkEnableOption "video";
    };

    # should the device load bluetooth drivers and enable blueman
    bluetooth = {
      enable = mkEnableOption "bluetooth";
    };

    # should the device enable printing module and try to load common printer modules
    # you might need to add more drivers to the printing module for your printer to work
    printing = {
      enable = mkEnableOption "printing";
    };

    # should virtualization be enabled
    # TODO: this will probably create issues if virtualization module is not hotplugged
    virtualization = {
      enable = mkEnableOption "virtualization";
    };
  };

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
      type = types.enum ["hyprland"];
      default = "";
    };

    # should home manager be enabled
    # you NEED to set a username if you want to use home-manager
    useHomeManager = mkOption {
      type = types.bool;
      default = false;
    };
  };

  # this module provides overrides for certain defaults and lets you set
  # default programs for referencing in other config files.
  options.modules.programs = {
    # TODO: turn those into overrides
    cli = {
      enabled = mkEnableOption "cli";
    };

    gui = {
      enabled = mkEnableOption "gui";
    };

    # default program options
    default = {
      # what program should be used as the default terminal
      # do note this is NOT the command, just the name. i.e setting footclient will
      # not work.
      terminal = mkOption {
        type = types.str;
        default = "foot";
      };
    };

    overrides = {
      # TODO: individual overrides to disable programs enabled by device.type opt
    };
  };
}
