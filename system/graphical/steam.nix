{
  config,
  pkgs,
  lib,
  ...
}: {
  # Set required env variables from hyprland's wiki
  environment = {
    systemPackages = with pkgs; [
      steam
    ];
  };

  # xdg portal is required for screenshare
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  services.xserver.videoDrivers = ["nvidia"];
  environment.systemPackages = [
    nvidia-offload
    libgdiplus
    glxinfo
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
