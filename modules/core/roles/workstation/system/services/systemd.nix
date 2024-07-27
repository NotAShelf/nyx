{lib, ...}: let
  inherit (lib.modules) mkForce;
  inherit (lib.attrsets) mapAttrs;
in {
  systemd = let
    timeoutConfig = ''
      DefaultTimeoutStartSec=10s
      DefaultTimeoutStopSec=10s
      DefaultTimeoutAbortSec=10s
      DefaultDeviceTimeoutSec=10s
    '';
  in {
    # Set the default timeout for starting, stopping, and aborting services to
    # avoid hanging the system for too long on boot or shutdown.
    extraConfig = timeoutConfig;
    user.extraConfig = timeoutConfig;

    # Disable all virtual terminals. I usually don't need to switch between
    # TTYs, however, I may get locked out of my desktop session and this
    # may come to bite me in the ass when that happens.
    services = mapAttrs (_: mkForce) {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
      "getty@tty7".enable = false;
      "autovt@tty7".enable = false;
      "kmsconvt@tty1".enable = false;
      "kmsconvt@tty7".enable = false;
    };
  };
}
