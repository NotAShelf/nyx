{
  imports = [
    ./systemd

    ./fwupd.nix
    ./getty.nix
    ./logrotate.nix
    ./ntpd.nix
    ./thermald.nix
    ./zram.nix
  ];
}
