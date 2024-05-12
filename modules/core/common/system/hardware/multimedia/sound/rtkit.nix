{config, ...}: {
  # able to change scheduling policies, e.g. to SCHED_RR
  # sounds server use RealtimeKit (rtkit) to acquire
  # realtime priority
  security.rtkit.enable = config.services.pipewire.enable;
}
