{
  config = {
    fileSystems = {
      "/".options = ["compress=zstd" "noatime"];
      "/nix".options = ["compress=zstd" "noatime"];
      "/var/log".options = ["compress=zstd" "noatime"];
      "/home".options = ["compress=zstd"];
    };
  };
}
