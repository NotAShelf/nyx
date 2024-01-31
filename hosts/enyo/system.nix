{pkgs, ...}: {
  config = {
    services = {
      hardware.openrgb = {
        enable = true;
        package = pkgs.openrgb-with-all-plugins;
      };
    };
  };
}
