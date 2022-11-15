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
  # Fix nvidia stuff on wayland
in {
  # Set required env variables from hyprland's wiki
  environment = {
    variables = {
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
  };

  services.xserver.videoDrivers = ["nvidia"];
  environment.systemPackages = with pkgs; [
    nvidia-offload
    glxinfo
    nvidia-vaapi-driver
  ];

  hardware = {
    nvidia = {
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
  };
}
