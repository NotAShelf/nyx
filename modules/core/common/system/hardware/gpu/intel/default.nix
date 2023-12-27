{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  dev = config.modules.device;

  # let me play youtube videos without h.264, please and thank you
  vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
in {
  config = mkIf (builtins.elem dev.gpu.type ["intel" "hybrid-intel"]) {
    # enable the i915 kernel module
    boot.initrd.kernelModules = ["i915"];
    # better performance than the actual Intel driver
    services.xserver.videoDrivers = ["modesetting"];

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
        # intel-compute-runtime # FIXME does not build due to unsupported system
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    environment.variables = mkIf (config.hardware.opengl.enable && dev.gpu != "hybrid-nv") {
      VDPAU_DRIVER = "va_gl";
    };
  };
}
