{
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) filter;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) listOf str;
in {
  options.modules.system.emulation = {
    # should we enable emulation for additional architectures?
    # enabling this option will make it so that you can build for, e.g.
    # aarch64 on x86_&4 and vice verse - not recommended on weaker machines
    enable = mkEnableOption ''
      emulation of additional arcitechtures via binfmt. Enabling this
      option will make it so that the system can build for additional
      systems such as aarch64 on x86_64 and vice versa.
    '';

    systems = mkOption {
      type = listOf str;
      default = filter (sys: sys != pkgs.stdenv.system) ["aarch64-linux" "i686-linux" "armv7l-linux"];
      description = ''
        Systems that will be emulated by the host system.

        If overriding the default, you must make sure that the list of systems
        does not contain the same system as the host in order to avoid
        an unbootable machine.
      '';
    };
  };
}
