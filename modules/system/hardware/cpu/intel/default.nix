{
  config,
  lib,
  pkg,
  ...
}:
with lib; let
  device = config.modules.device;
in {
  config = mkIf (device.cpu == "intel" || device.cpu == "vm-intel") {
    hardware.cpu.intel.updateMicrocode = true;
    boot = {
      kernelModules = ["kvm-intel"];
      kernelParams = ["i915.fastboot=1" "i915.enable_fbc=1" "enable_gvt=1"];
    };
  };
}
