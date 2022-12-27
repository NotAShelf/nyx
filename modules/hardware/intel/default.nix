{
  config,
  lib,
  pkgs,
  ...
}: {
  boot.initrd.kernelModules = ["i915"];

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
  };

  environment.variables = {
    VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
  };

  hardware = {
    opengl = {
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        intel-media-driver
        vaapiIntel
      ];
    };
  };
}
