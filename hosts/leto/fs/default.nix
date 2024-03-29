{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/4e742f36-b005-4f3b-a25c-dd55ef1bda0a";
    fsType = "btrfs";
    options = ["compress=zstd" "noatime"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/8d35941a-dcf0-4659-83f8-458c18d0bb4f";}
  ];
}
