{
  config,
  pkgs,
  lib,
  ...
}: {
  services.xserver.videoDrivers = ["nvidia"];
  environment.systemPackages = [
    pkgs.libgdiplus
  ];

  hardware = {
    nvidia = {
      open = true;
      powerManagement.enable = true;
      modesetting.enable = true;
      prime = {
        offload.enable = true;

        # Bus ID for the Intel iGPU
        intelBusId = "PCI:00:02.0";

        # bUS ID for the NVIDIA dGPU
        nvidiaBusId = "PCI:01:00.0";
      };
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        intel-compute-runtime
        vaapiVdpau
        libvdpau-va-gl
        nvidia-vaapi-driver
      ];
    };
  };
}
