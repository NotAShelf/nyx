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
  services.xserver.videoDrivers = ["nvidia"];

  environment = {
    variables = {
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
    systemPackages = with pkgs; [
      nvidia-offload
      glxinfo
      nvtop
    ];
  };

  hardware = {
    nvidia = {
      # BREAKS MOZILLA PRODUCTS FOR SOME REASON #
      #package = let
      #  nv = config.boot.kernelPackages.nvidiaPackages;
      #in
      #  if lib.versionAtLeast nv.stable.version nv.beta.version
      #  then nv.stable
      #  else nv.beta;
      open = true;
      powerManagement.enable = true;
      modesetting.enable = true;
      prime = {
        #sync.enable = true;
        offload.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    opengl.extraPackages = with pkgs; [nvidia-vaapi-driver];
  };
}
