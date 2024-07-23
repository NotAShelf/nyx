{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) elem;
  inherit (lib.modules) mkIf;

  dev = config.modules.device;
in {
  config = mkIf (elem dev.cpu.type ["intel" "vm-intel"]) {
    hardware.cpu.intel.updateMicrocode = true;
    boot = {
      kernelModules = ["kvm-intel"];
      kernelParams = ["i915.fastboot=1" "enable_gvt=1"];
    };

    environment.systemPackages = [pkgs.intel-gpu-tools];
  };
}
