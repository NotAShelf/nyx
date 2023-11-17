{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  dev = config.modules.device;
in {
  config = mkIf (dev.cpu == "amd" || dev.cpu == "vm-amd") {
    hardware.cpu.amd.updateMicrocode = true;
    boot.kernelModules = [
      "kvm-amd"
      "amd-pstate" # load pstate module in case the device has a newer gpu
    ];
  };
}
