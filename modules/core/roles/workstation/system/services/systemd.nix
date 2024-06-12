{lib, ...}: let
  inherit (lib.modules) mkForce;
  inherit (lib.attrsets) mapAttrs;
in {
  systemd = let
    extraConfig = ''
      DefaultTimeoutStartSec=15s
      DefaultTimeoutStopSec=15s
      DefaultTimeoutAbortSec=15s
      DefaultDeviceTimeoutSec=15s
    '';
  in {
    inherit extraConfig;
    user = {inherit extraConfig;};

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
