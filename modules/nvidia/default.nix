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
in {
  services.xserver = {
    videoDrivers = ["nvidia"];
    screenSection = ''
      Option         "UseNvKmsCompositionPipeline" "false"
      Option         "metamodes" "nvidia-auto-select +0+0 {ForceCompositionPipeline=On,AllowGSYNCCompatible=On}"
    '';
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
    ];

  environment = {
    variables = {
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
    systemPackages = with pkgs; [
      nvidia-offload
      glxinfo
      nvidia-vaapi-driver
      nvtop
    ];
  };

  hardware = {
    nvidia = {
      package = let
        nv = config.boot.kernelPackages.nvidiaPackages;
      in
        if lib.versionAtLeast nv.stable.version nv.beta.version
        then nv.stable
        else nv.beta;
      open = true;
      powerManagement.enable = true;
      modesetting.enable = true;
      prime = {
        offload.enable = true;

        # Bus ID for the Intel iGPU
        intelBusId = "PCI:0:2:0";

        # bUS ID for the NVIDIA dGPU
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    opengl.extraPackages = with pkgs; [nvidia-vaapi-driver];
  };
}
