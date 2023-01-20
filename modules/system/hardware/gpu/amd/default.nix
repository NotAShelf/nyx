{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  device = config.modules.device;
in {
  config = mkIf (device.gpu == "amd" || device.gpu == "hybrid-amd") {
    # enable amdgpu kernel module
    boot.initrd.kernelModules = ["amdgpu"];
    services.xserver.videoDrivers = ["amdgpu"];
    # enables AMDVLK & OpenCL support
    hardware.opengl.extraPackages = with pkgs; [
      amdvlk
      # opencl drivers
      rocm-opencl-icd
      rocm-opencl-runtime
    ];
    hardware.opengl.extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
    # force use of RADV, can be unset if AMDVLK should be used
    environment.variables.AMD_VULKAN_ICD = "RADV";
  };
}
