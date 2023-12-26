_: let
  mkBtrfs = list: list + ["compress=zstd" "noatime"];
in {
  inherit mkBtrfs;
}
