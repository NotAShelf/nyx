{lib}: let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) str int;

  # The `mkModule` function takes a few arguments to generate
  # a module for a service without repeating the same options
  # over and over: every online service needs a host and a port.
  # I can't exactly tell you why, but if I am to be honest
  # this is actually a horrendous abstraction
  mkModule = {
    name,
    type ? "", # type being an empty string means it can be skipped, omitted
    host ? "127.0.0.1", # default to listening only on localhost
    port ? 0, # default port should be a stub
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
