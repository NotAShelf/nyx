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

  cfg = config.modules.device;
in {
  config = {
    services.xserver.videoDrivers = ["nvidia" "modesetting"];
    boot.blacklistedKernelModules = ["nouveau"];

    environment = {
      variables = {
        GBM_BACKEND = "nvidia-drm";
        LIBVA_DRIVER_NAME = "nvidia";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        WLR_NO_HARDWARE_CURSORS = "1";
      };
      systemPackages = with pkgs; [
        nvidia-offload
        glxinfo
        vulkan-tools
        glmark2
        nvtop
      ];
    };

    hardware = {
      nvidia = {
        package = nvidiaPackage;

        powerManagement.enable = false;
        modesetting.enable = true;

        open = lib.mkDefault true; # use open source drivers where possible
        nvidiaSettings = true; # add nvidia-settings to pkgs
      };

      opengl.extraPackages = with pkgs; [nvidia-vaapi-driver];
      opengl.extraPackages32 = with pkgs.pkgsi686Linux; [nvidia-vaapi-driver];
    };
  };
}
