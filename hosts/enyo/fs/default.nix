{
  imports = [./external.nix];
  config = {
    fileSystems = {
      "/boot" = {
        device = "/dev/disk/by-uuid/E20E-9940";
        fsType = "vfat";
      };

      "/" = {
        device = "/dev/disk/by-uuid/e1f1186b-2143-4bf7-8b99-8da1434520c6";
        fsType = "btrfs";
        options = ["subvol=root" "compress=zstd" "noatime"];
      };

      "/nix" = {
        device = "/dev/disk/by-uuid/e1f1186b-2143-4bf7-8b99-8da1434520c6";
        fsType = "btrfs";
        options = ["subvol=nix" "compress=zstd" "noatime"];
      };

      "/home" = {
        device = "/dev/disk/by-uuid/e1f1186b-2143-4bf7-8b99-8da1434520c6";
        fsType = "btrfs";
        options = ["subvol=home" "compress=zstd"];
      };

      "/persist" = {
        device = "/dev/disk/by-uuid/e1f1186b-2143-4bf7-8b99-8da1434520c6";
        fsType = "btrfs";
        options = ["subvol=persist" "compress=zstd" "noatime"];
      };

      "/var/log" = {
        device = "/dev/disk/by-uuid/e1f1186b-2143-4bf7-8b99-8da1434520c6";
        fsType = "btrfs";
        options = ["subvol=log" "compress=zstd" "noatime"];
      };
    };

    # Swap Devices
    swapDevices = [{device = "/dev/disk/by-uuid/62fc1f62-55ae-432d-8623-74ea6511410c";}];
  };
}
