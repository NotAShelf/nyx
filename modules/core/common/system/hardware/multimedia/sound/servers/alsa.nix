{lib, ...}: let
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.modules) mkForce;
in {
  # the `sound` option is just a weird alias for system-wide ALSA configuration
  # since we prefer to use PipeWire as the primary sound server, this can be kept
  # as false - this has nothing to do with whether the system has sound.
  sound = mapAttrs (_: mkForce) {
    enable = false; # disable system-wide ALSA
    mediaKeys.enable = false; # most DE/WMs do this better, and it's annoying
    enableOSSEmulation = false; # doesn't play nicely with recent audio cardss
  };
}
