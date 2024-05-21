{
  imports = [
    ./systemd

    ./fwupd.nix
    ./logrotate.nix
    ./ntpd.nix
    ./thermald.nix
    ./zram.nix
  ];
}
