{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkForce;
in {
  # able to change scheduling policies, e.g. to SCHED_RR
  # sounds server use RealtimeKit (rtkit) to acquire
  # realtime priority
  security.rtkit.enable = mkForce config.services.pipewire.enable;
}
