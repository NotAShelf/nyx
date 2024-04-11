{
  imports = [
    ./systemd

    ./fstrim.nix
    ./fwupd.nix
    ./logrotate.nix
    ./lvm.nix
    ./ntpd.nix
    ./thermald.nix
    ./zram.nix
  ];
}
