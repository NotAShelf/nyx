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

  # use the latest possible nvidia package
  nvStable = config.boot.kernelPackages.nvidiaPackages.stable.version;
  nvBeta = config.boot.kernelPackages.nvidiaPackages.beta.version;

  nvidiaPackage =
    if (versionOlder nvBeta nvStable)
    then config.boot.kernelPackages.nvidiaPackages.stable
    else config.boot.kernelPackages.nvidiaPackages.beta;

  device = config.modules.device;
  env = config.modules.usrEnv;
in {
  config = mkIf (device.gpu == "nvidia" || device.gpu == "hybrid-nv") {
    # nvidia drivers are unfree software
    nixpkgs.config.allowUnfree = true;

    services.xserver = {
      videoDrivers = ["nvidia"];

      # disable DPMS
      monitorSection = ''
        Option "DPMS" "false"
      '';

      # disable screen blanking in total
      serverFlagsSection = ''
        Option "StandbyTime" "0"
        Option "SuspendTime" "0"
        Option "OffTime" "0"
        Option "BlankTime" "0"
      '';
    };

    boot = {
      # blacklist nouveau module so that it does not conflict with nvidia drm stuff
      # also the nouveau performance is godawful, I'd rather run linux on a piece of paper than use nouveau
      blacklistedKernelModules = [
        "nouveau"
      ];
    };

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

        (mkIf ((env.isWayland) && (device.gpu == "hybrid-nv")) {
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
        libva
        libva-utils
      ];
    };

    hardware = {
      nvidia = {
        package = mkDefault nvidiaPackage;
        modesetting.enable = mkDefault true;
        powerManagement = {
          enable = mkDefault true;
          finegrained = mkDefault true;
        };

        # use open source drivers by default, hosts may override this option if their gpu is
        # not supported by the open source drivers
        open = mkDefault true;
        nvidiaSettings = false; # add nvidia-settings to pkgs, useless on nixos
        nvidiaPersistenced = true;
        forceFullCompositionPipeline = true;
      };

      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        extraPackages = with pkgs; [nvidia-vaapi-driver];
        extraPackages32 = with pkgs.pkgsi686Linux; [nvidia-vaapi-driver];
      };
    };
  };
}
