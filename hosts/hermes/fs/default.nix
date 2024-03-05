{
  boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/0eb8b547-3644-4d49-a4e9-c28c395b8568";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/c9527aaf-947d-4dc0-88ab-3af438e3f5b1";
      fsType = "btrfs";
      options = ["subvol=root" "compress=zstd" "noatime"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/4F12-E737";
      fsType = "vfat";
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/c9527aaf-947d-4dc0-88ab-3af438e3f5b1";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd" "noatime"];
    };

    "/persist" = {
      device = "/dev/disk/by-uuid/c9527aaf-947d-4dc0-88ab-3af438e3f5b1";
      fsType = "btrfs";
      neededForBoot = true;
      options = ["subvol=persist" "compress=zstd" "noatime"];
    };

    "/var/log" = {
      device = "/dev/disk/by-uuid/c9527aaf-947d-4dc0-88ab-3af438e3f5b1";
      fsType = "btrfs";
      neededForBoot = true;
      options = ["subvol=log" "compress=zstd" "noatime"];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/c9527aaf-947d-4dc0-88ab-3af438e3f5b1";
      fsType = "btrfs";
      options = ["subvol=home" "compress=zstd"];
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/b55b09f2-b567-4fbf-9150-b05b91710ca2";}
  ];
}
