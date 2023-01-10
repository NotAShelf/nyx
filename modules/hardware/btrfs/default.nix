{...}: {
  boot = {
    initrd = {
      supportedFilesystems = ["btrfs"];
    };
  };

  services.btrfs.autoScrub.enable = true;
}
