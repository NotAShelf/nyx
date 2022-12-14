{pkgs, ...}: {
  hardware = {
    opengl = {
      extraPackages = with pkgs; [
        intel-compute-runtime
        intel-media-driver
        vaapiIntel
      ];
    };
  };
}
