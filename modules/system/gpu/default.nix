{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.system.video;
  device = config.modules.device;
in {
  options.modules.system.video = {enable = mkEnableOption "video";};

  config = mkIf (cfg.enable) (mkMerge [
    {
      hardware = {
        opengl = {
          enable = true;
          driSupport = true;
          driSupport32Bit = true;
        };
      };
      users.users.${device.username}.extraGroups = ["video"];
    }

    (lib.mkIf (device.gpu == "nvidia") {
      imports = [
        ../hardware/nvidia
      ];
    })

    (lib.mkIf (device.gpu == "nvHybrid") {
      imports = [
        ./intel.nix
        ./nvidia.nix
      ];
    })

    (lib.mkIf (device.gpu == "intel") {
      imports = [
        ./intel.nix
      ];
    })

    (mkIf (device.gpu == "amd") {
      # enable amdgpu kernel module
      boot.initrd.kernelModules = ["amdgpu"];
      services.xserver.videoDrivers = ["amdgpu"];
      # enables AMDVLK & OpenCL support
      hardware.opengl.extraPackages = with pkgs; [
        amdvlk
        rocm-opencl-icd
        rocm-opencl-runtime
      ];
      hardware.opengl.extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
      # force use of RADV, can be unset if AMDVLK should be used
      environment.variables.AMD_VULKAN_ICD = "RADV";
    })
  ]);
}
