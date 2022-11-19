{
  config,
  pkgs,
  lib,
  ...
}: {
  fileSystems = {
    "/".options = ["noatime"];
    "/home".options = ["compress=zstd"];
    "/nix".options = ["compress=zstd" "noatime"];
  };
}
