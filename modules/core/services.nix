{
  config,
  pkgs,
  lib,
  ...
}: {
  services = {
    resolved.enable = true;

    lorri.enable = true;
    fstrim.enable = true;
  };
}
