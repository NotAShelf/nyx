{
  imports = [./external.nix];
  config = {
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/783e926f-acd7-4684-a7b3-f5b1ecefa11b";
      fsType = "ext4";
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/d1d77f8e-7c77-40c9-a5e8-59d962f4d397";}
    ];
  };
}
