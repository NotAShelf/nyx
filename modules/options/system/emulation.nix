{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  options.modules.system.emulation = {
    # should we enable emulation for additional architechtures?
    # enabling this option will make it so that you can build for, e.g.
    # aarch64 on x86_&4 and vice verse - not recommended on weaker machines
    enable = mkEnableOption ''
      emulation of additional arcitechtures via binfmt. Enabling this option will make it so that the system can build for
      addiitonal systems such as aarc64 on x86_64 and vice versa.
    '';

    systems = mkOption {
      type = with types; listOf str;
      # default = ["x86_64-linux" "aarch64-linux" "i686-linux"];
      default = builtins.filter (system: system != pkgs.system) ["aarch64-linux" "i686-linux"];
      description = ''
        Systems that will be emulated by the host system.

        If overriding the default, you must make sure that the list of systems does not contain the same system as the host
        in order to avoid an unbootable machine.
      '';
    };
  };
}
