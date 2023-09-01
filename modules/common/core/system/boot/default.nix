_: {
  imports = [
    ./loader # per-bootloader configurations
    ./secure-boot # secure boot module
    ./generic # generic configuration, such as kernel and tmpfs setup
    ./plymouth # plymouth boot splash
    ./encryption # LUKS encryption and optimizations for FDE
  ];
}
