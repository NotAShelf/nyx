{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/b26ec8d8-8203-4252-8c32-0e0de3d90477";
      fsType = "btrfs";
      options = ["subvol=root" "compress=zstd"];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/b26ec8d8-8203-4252-8c32-0e0de3d90477";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd" "noatime"];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/b26ec8d8-8203-4252-8c32-0e0de3d90477";
      fsType = "btrfs";
      options = ["subvol=home" "compress=zstd"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/1EC3-9305";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/2691cd3d-8c61-415f-9260-395050884f02";}
  ];
}
