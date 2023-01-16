{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    #!/bin/bash
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';

  nvStable = config.boot.kernelPackages.nvidiaPackages.stable.version;
  nvBeta = config.boot.kernelPackages.nvidiaPackages.beta.version;
  nvidiaPackage =
    if (lib.versionOlder nvBeta nvStable)
    then config.boot.kernelPackages.nvidiaPackages.stable
    else config.boot.kernelPackages.nvidiaPackages.beta;

  device = config.modules.device;
  env = config.modules.usrEnv;
in {
  config = mkIf (device.gpu == "nvidia" || device.gpu == "nvHybrid") {
    services.xserver.videoDrivers = ["nvidia" "modesetting"];
    boot.blacklistedKernelModules = ["nouveau"];

    environment = {
      sessionVariables = mkMerge [
        {
          LIBVA_DRIVER_NAME = "nvidia";
        }
        (mkIf (env.isWayland) {
          WLR_NO_HARDWARE_CURSORS = "1";
          GBM_BACKEND = "nvidia-drm";
          __GL_GSYNC_ALLOWED = "0";
          __GL_VRR_ALLOWED = "0";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        })

        (mkIf (cfg.gpu == "nvHybrid") {
          WLR_DRM_DEVICES = mkDefault "/dev/dri/card1:/dev/dri/card0";
        })
      ];
      systemPackages = with pkgs; [
        nvidia-offload
        glxinfo
        vulkan-tools
        vulkan-loader
        vulkan-validation-layers
        glmark2
        nvtop
      ];
    };

    hardware = {
      nvidia = {
        package = mkDefault nvidiaPackage;

        powerManagement.enable = false;
        modesetting.enable = true;

        open = mkDefault true; # use open source drivers where possible
        nvidiaSettings = true; # add nvidia-settings to pkgs
      };

      opengl.extraPackages = with pkgs; [nvidia-vaapi-driver];
      opengl.extraPackages32 = with pkgs.pkgsi686Linux; [nvidia-vaapi-driver];
    };
  };
}
