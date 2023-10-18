{
  config,
  lib,
  ...
}:
with lib; let
  device = config.modules.device;
in {
  config = mkIf (device.cpu == "amd" || device.cpu == "vm-amd") {
    hardware.cpu.amd.updateMicrocode = true;
    boot.kernelModules = [
      "kvm-amd"
      "amd-pstate" # load pstate module in case the device has a newer gpu
    ];
  };
}
