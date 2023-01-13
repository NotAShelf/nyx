{
  config,
  lib,
  pkgs,
}:
with lib; let
  device = config.modules.device;
in {
  config = mkIf (device.gpu == "intel" || device.gpu == "nvHybrid") {
    # enable the i915 kernel module
    boot.initrd.kernelModules = ["i915"];
    # better performance than the actual Intel driver
    services.xserver.videoDrivers = ["modesetting"];

    nixpkgs.config.packageOverrides = pkgs: {
      # let me play youtube videos without h.264, please and thank you
      vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
    };

    # OpenCL support and VAAPI
    hardware.opengl = {
      extraPackages = with pkgs; [
        intel-compute-runtime
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];

      extraPackages32 = with pkgs.pkgsi686Linux; [
        intel-compute-runtime
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    environment.variables = {
      VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
    };
  };
}
