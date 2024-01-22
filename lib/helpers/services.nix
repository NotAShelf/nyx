{lib}: let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) str int;

  # mkModule takes a few arguments to generate a module for a service without
  # repeating the same options over and over
  # this is actually a horrendous abstractation
  mkModule = {
    name,
    type ? "", # type being an empty string means it can be skipped, ommitted
    host ? "127.0.0.1", # default to listening only on localhost
    port ? 0, # don't set a port by default
    extraOptions ? {}, # used to define additional modules
  }: {
    enable = mkEnableOption "${name} ${type} service";
    settings =
      {
        host = mkOption {
          type = str;
          default = host;
          description = "The host ${name} will listen on";
        };

        port = mkOption {
          type = int;
          default = port;
          description = "The port ${name} will listen on";
        };
      }
      // extraOptions;
  };
in {
  inherit mkModule;
}
