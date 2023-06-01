_: {
  imports = [
    ./common.nix
    ./server.nix
    # TODO: separate loaderrs into grub and systemd-boot
    # move common/server loader option to profiles, and avoid autodetecting
  ];
}
