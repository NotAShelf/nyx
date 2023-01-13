{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  device = config.modules.device;
in {
  config = mkMerge [
    (mkIf (device.cpu == "intel") {
      hardware.cpu.intel.updateMicrocode = true;
      boot.kernelModules = ["kvm-intel"];
    })

    (mkIf (device.cpu == "amd") {
      hardware.cpu.amd.updateMicrocode = true;
      boot.kernelModules = ["kvm-amd"];
    })

    (mkIf (device.cpu == "vm-intel") {
      hardware.cpu.intel.updateMicrocode = true;
      boot = {
        kernelModules = ["kvm-intel"];
        kernelParams = ["i915.fastboot=1" "i915.enable_fbc=1" "enable_gvt=1"];
      };
    })

    (mkIf (device.cpu == "vm-amd") {
      hardware.cpu.amd.updateMicrocode = true;
      boot.kernelModules = ["kvm-amd"];
    })
  ];
}
