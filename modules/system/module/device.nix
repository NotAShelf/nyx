{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
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
    # TODO: make this a list - apparently more than one cpu on a device is still doable
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

    # bluetooth is an insecure protocol if left unchedked, so while this defaults to true
    # but the bluetooth.enable option does and should not.
    hasBluetooth = mkOption {
      type = types.bool;
      default = true;
      description = "Whether or not the system has bluetooth support";
    };

    # whether the system has sound support (usually true except for servers)
    # TODO: hook music tagger programs to the evaluation of this option
    hasSound = mkOption {
      type = types.bool;
      default = true;
    };

    # whether the system has tpm support - win11 style
    hasTPM = mkOption {
      type = types.bool;
      default = false;
    };
  };
}
