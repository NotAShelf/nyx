{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  dev = config.modules.device;
in {
  config = mkIf (dev.gpu == "amd" || dev.gpu == "hybrid-amd") {
    # enable amdgpu xorg drivers in case Hyprland breaks again
    services.xserver.videoDrivers = ["amdgpu"];

    # enable amdgpu kernel module
    boot = {
      initrd.kernelModules = ["amdgpu"]; # load amdgpu kernel module as early as initrd
      kernelModules = ["amdgpu"]; # if loading somehow fails during initrd but the boot continues, try again later
    };

    # enables AMDVLK & OpenCL support
    hardware.opengl.extraPackages = with pkgs; [
      amdvlk
      # opencl drivers
      rocm-opencl-icd
      rocm-opencl-runtime

      # mesa
      mesa

      # vulkan
      vulkan-tools
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];

    hardware.opengl.extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
      rocm-opencl-icd
      rocm-opencl-runtime
      driversi686Linux.mesa
    ];
  };
}
