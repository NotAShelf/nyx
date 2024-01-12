{
  config,
  lib,
  ...
}: let
  inherit (lib) types;
  inherit (lib.options) mkOption;
in {
  options.meta = {
    hostname = mkOption {
      type = types.str;
      default = config.networking.hostName;
      internal = true;
      description = ''
        The canonical hostname of the machine.

        Is usually used to identify - i.e name machines internally
        or on the same Headscale network. This option must be declared
        in `hosts.nix` alongside host system.
      '';
    };

    system = mkOption {
      type = types.str;
      default = config.system.build.toplevel.system;
      internal = true;
      description = ''
        The architecture of the machine.
      '';
    };
  };
}
