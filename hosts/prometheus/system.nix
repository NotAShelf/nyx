{
  config,
  pkgs,
  lib,
  ...
}: {
  boot = {
    loader.systemd-boot.enable = true;
  };
  fileSystems = {
    "/".options = ["noatime"];
    "/home".options = ["compress=zstd"];
    "/nix".options = ["compress=zstd" "noatime"];
  };
}
