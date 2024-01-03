{
  systemd = {
    # TODO: those tend to include sensitie information, maybe we want to disable this?
    # it could be an override in the security module
    tmpfiles.rules = [
      # Enables storing of the kernel log (including stack trace) into pstore upon a panic or crash.
      "w /sys/module/kernel/parameters/crash_kexec_post_notifiers - - - - Y"
      # Enables storing of the kernel log upon a normal shutdown (shutdown, reboot, halt).
      "w /sys/module/printk/parameters/always_kmsg_dump - - - - N"
    ];
  };
}
