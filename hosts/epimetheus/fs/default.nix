{
  boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/82144284-cf1d-4d65-9999-2e7cdc3c75d4";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/b79d3c8b-d511-4d66-a5e0-641a75440ada";
      fsType = "btrfs";
      options = ["subvol=root"];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/b79d3c8b-d511-4d66-a5e0-641a75440ada";
      fsType = "btrfs";
      options = ["subvol=home"];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/b79d3c8b-d511-4d66-a5e0-641a75440ada";
      fsType = "btrfs";
      options = ["subvol=nix"];
    };

    "/persist" = {
      device = "/dev/disk/by-uuid/b79d3c8b-d511-4d66-a5e0-641a75440ada";
      fsType = "btrfs";
      options = ["subvol=persist"];
      neededForBoot = true;
    };

    "/var/log" = {
      device = "/dev/disk/by-uuid/b79d3c8b-d511-4d66-a5e0-641a75440ada";
      fsType = "btrfs";
      options = ["subvol=log"];
      neededForBoot = true;
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/FDED-3BCF";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/0d1fc824-623b-4bb8-bf7b-63a3e657889d";}
  ];
}
