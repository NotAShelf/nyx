{
  # Some values here are borrowed from nix-comunity/srvos project.
  # See:
  #  <https://github.com/nix-community/srvos/blob/e3e8ff545ef14f13c69a0f743078637fde952018/nixos/server/default.nix>
  systemd = {
    # On a headless system, emergency mode is practically useless unless there is
    # a way to physically access a console, e.g., Hetzner's cloud console. Disable
    # emergency mode so that the system goes back into a boot loop that we may be
    # able to use to debug our system.
    enableEmergencyMode = false;

    # For more detail, see:
    #  <https://0pointer.de/blog/projects/watchdog.html>
    watchdog = {
      # Hardcode the watchdog device to /dev/watchdog. This is the default
      # but we'd like to avoid surprises.
      device = "/dev/watchdog";
      # Systemd will send a signal to the hardware watchdog at half
      # the interval defined here, so every 10s.
      # If the hardware watchdog does not get a signal for 20s,
      # it will forcefully reboot the system.
      runtimeTime = "20s";
      # Forcefully reboot if the final stage of the reboot
      # hangs without progress for more than 30s.
      # For more info, see:
      #   https://utcc.utoronto.ca/~cks/space/blog/linux/SystemdShutdownWatchdog
      rebootTime = "30s";
    };

    sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
    '';
  };
}
