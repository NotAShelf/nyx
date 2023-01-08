{
  config,
  lib,
  pkgs,
  ...
}: {
  boot.initrd.kernelModules = ["i915"];

  boot.kernelParams = ["i915.fastboot=1" "i915.enable_fbc=1" "enable_gvt=1"];

  nixpkgs.config.packageOverrides = pkgs: {
    # let me play youtube videos without h.264, please and thank you
    vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
  };

  environment.variables = {
    VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
  };

  hardware = {
    opengl = {
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        intel-media-driver
        vaapiIntel
      ];
    };
  };
}
