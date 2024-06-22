{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  dev = config.modules.device;
in {
  config = mkIf (builtins.elem dev.gpu.type ["amd" "hybrid-amd"]) {
    # enable amdgpu xorg drivers in case Hyprland breaks again
    services.xserver.videoDrivers = lib.mkDefault ["modesetting" "amdgpu"];

    # enable amdgpu kernel module
    boot = {
      initrd.kernelModules = ["amdgpu"]; # load amdgpu kernel module as early as initrd
      kernelModules = ["amdgpu"]; # if loading somehow fails during initrd but the boot continues, try again later
    };

    environment.systemPackages = [pkgs.nvtopPackages.amd];

    # enables AMDVLK & OpenCL support
    hardware.graphics = {
      extraPackages = with pkgs;
        [
          amdvlk

          # mesa
          mesa

          # vulkan
          vulkan-tools
          vulkan-loader
          vulkan-validation-layers
          vulkan-extension-layer
        ]
        ++ (
          # this is a backwards-compatible way of loading appropriate opencl packages
          # in case the host runs an older revision of nixpkgs
          if pkgs ? rocmPackages.clr
          then with pkgs.rocmPackages; [clr clr.icd]
          else with pkgs; [rocm-opencl-icd rocm-opencl-runtime]
        );

      extraPackages32 = [pkgs.driversi686Linux.amdvlk];
    };
  };
}
