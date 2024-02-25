{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/5e652a20-9dc3-441a-9fc3-949d5263ee7a";
      fsType = "btrfs";
      options = ["subvol=root"];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/5e652a20-9dc3-441a-9fc3-949d5263ee7a";
      fsType = "btrfs";
      options = ["subvol=home"];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/5e652a20-9dc3-441a-9fc3-949d5263ee7a";
      fsType = "btrfs";
      options = ["subvol=nix"];
    };

    "/persist" = {
      device = "/dev/disk/by-uuid/5e652a20-9dc3-441a-9fc3-949d5263ee7a";
      fsType = "btrfs";
      options = ["subvol=persist"];
    };

    "/var/log" = {
      device = "/dev/disk/by-uuid/5e652a20-9dc3-441a-9fc3-949d5263ee7a";
      fsType = "btrfs";
      options = ["subvol=log"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/6ABE-DA15";
      fsType = "vfat";
    };
  };
}
