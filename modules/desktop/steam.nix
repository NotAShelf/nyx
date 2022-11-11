{
  config,
  pkgs,
  lib,
  ...
}: {
  # Set required env variables from hyprland's wiki
  config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs:
        with pkgs; [
          keyutils
          libkrb5
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          xorg.libXcursor
          xorg.libXi
          xorg.Libxinerama
          xorg.libXScrnSaver
        ];
      extraProfile = "export GDK_SCALE=2";
    };
  };

  # xdg portal is required for screenshare
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

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
