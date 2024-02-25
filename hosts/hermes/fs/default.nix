{
  boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/0eb8b547-3644-4d49-a4e9-c28c395b8568";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/c9527aaf-947d-4dc0-88ab-3af438e3f5b1";
      fsType = "btrfs";
      options = ["subvol=root"];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/c9527aaf-947d-4dc0-88ab-3af438e3f5b1";
      fsType = "btrfs";
      options = ["subvol=nix"];
    };

    "/persist" = {
      device = "/dev/disk/by-uuid/c9527aaf-947d-4dc0-88ab-3af438e3f5b1";
      fsType = "btrfs";
      neededForBoot = true;
      options = ["subvol=persist"];
    };

    "/var/log" = {
      device = "/dev/disk/by-uuid/c9527aaf-947d-4dc0-88ab-3af438e3f5b1";
      fsType = "btrfs";
      neededForBoot = true;
      options = ["subvol=log"];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/c9527aaf-947d-4dc0-88ab-3af438e3f5b1";
      fsType = "btrfs";
      options = ["subvol=home"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/4F12-E737";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/b55b09f2-b567-4fbf-9150-b05b91710ca2";}
  ];
}
