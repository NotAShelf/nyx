{lib, ...}: let
  inherit (builtins) filter map toString elem;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.strings) hasSuffix;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) str int;

  # `mkModuleTree` is used to recursively import all Nix file in a given directory, assuming the
  # given directory to be the module root, where rest of the modules are to be imported. This
  # retains a sense of explicitness in the module tree, and allows for a more organized module
  # imports, discarding the vague `default.nix` name for directories that are *modules*.
  mkModuleTree = {
    path,
    ignoredPaths ? [./default.nix],
  }:
    filter (hasSuffix ".nix") (
      map toString (
        # List all files in the given path, and filter out paths that are in
        # the ignoredPaths list
        filter (path: !elem path ignoredPaths) (listFilesRecursive path)
      )
    );

  # A variant of mkModuleTree that provides more granular control over the files that are imported.
  # While `mkModuleTree` imports all Nix files in the given directory, `mkModuleTree'` will look
  # for a specific
  mkModuleTree' = {
    path,
    ignoredPaths ? [],
  }: (
    # Two conditions fill satisfy filter here:
    #  - The path should end with a module.nix, indicating
    #   that it is in fact a module file.
    #  - The path is not contained in the ignoredPaths list.
    # If we cannot satisfy both of the conditions, then the path will be ignored
    filter (hasSuffix "module.nix") (
      map toString (
        filter (path: !elem path ignoredPaths) (listFilesRecursive path)
      )
    )
  );

  # The `mkService` function takes a few arguments to generate
  # a module for a service without repeating the same options
  # over and over: every online service needs a host and a port.
  # I can't exactly tell you why, but if I am to be honest
  # this is actually a horrendous abstraction
  mkService = {
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
  inherit mkService mkModuleTree mkModuleTree';
}
