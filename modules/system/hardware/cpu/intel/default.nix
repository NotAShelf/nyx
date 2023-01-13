{
  config,
  lib,
  pkg,
}:
with lib; let
  cfg = config.modules.device;
in {
  config = mkIf (cfg.cpu == "intel" || cfg.cpu == "vm-intel") {
    hardware.cpu.intel.updateMicrocode = true;
    boot.kernelModules = ["kvm-intel"];
    kernelParams = ["i915.fastboot=1" "i915.enable_fbc=1" "enable_gvt=1"];
  };
}
