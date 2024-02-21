{
  imports = [
    ./systemd

    ./fstrim.nix
    ./fwupd.nix
    ./logrotate.nix
    ./lvm.nix
    ./thermald.nix
    ./zram.nix
  ];
}
