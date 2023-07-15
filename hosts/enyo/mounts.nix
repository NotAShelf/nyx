_: {
  fileSystems."/mnt/SLib1" = {
    device = "/dev/disk/by-uuid/4345570b-2bd6-4cb8-8ca1-eb05bcf12c05";
    fsType = "btrfs";
    options = ["nofail" "rw" "compress=zstd"];
  };
  fileSystems."/mnt/SLib2" = {
    device = "/dev/disk/by-uuid/080006fe-b012-4363-b596-c183b012c1de";
    fsType = "btrfs";
    options = ["nofail" "rw" "compress=zstd"];
  };
  fileSystems."/mnt/Storage" = {
    device = "/dev/disk/by-uuid/eb25f034-e5de-4c6c-89e9-f3dea10159a5";
    fsType = "btrfs";
    options = ["nofail" "rw" "compress=zstd"];
  };
  fileSystems."/mnt/Expansion" = {
    device = "/dev/disk/by-uuid/68a2203f-5ecd-4ddb-b66a-76eb8dcf328c";
    fsType = "btrfs";
    options = ["nofail" "rw" "compress=zstd"];
  };
  fileSystems."/mnt/Expansion2" = {
    device = "/dev/disk/by-uuid/9381fba0-e9b5-4574-9007-a0911cae4a08";
    fsType = "btrfs";
    options = ["nofail" "rw" "compress=zstd"];
  };
}
