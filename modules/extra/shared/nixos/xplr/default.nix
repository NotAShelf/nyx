{
  config,
  lib,
  pkgs,
  ...
}:
with builtins; let
  inherit (lib) types mkIf mkOption mkEnableOption mkPackageOptionMD mdDoc literalExpression;

  cfg = config.programs.xplr;
  initialConfig = ''
    version = '${cfg.package.version}'
  '';
  /*
  we provide a default version line within the configuration file, which is obtained from the package's attributes
  merge the initial configFile, a mapped list of plugins and then the user defined configuration to obtain the final configuration
  if the plugin list is empty, the generated config will be faulty, so we only append the plugin line if the list is not empty
  */

  # pluginpath is handled separately for readibility
  pluginPaths =
    if (cfg.plugins != [])
    then "package.path=\n" + (concatStringsSep " ..\n" (map (p: ''"${p}/init.lua;"'') cfg.plugins)) + " ..\npackage.path\n"
    else "";
  configFile = initialConfig + pluginPaths + cfg.extraConfig;
in {
  options.programs.xplr = {
    enable = mkEnableOption "xplr, terminal UI based file explorer" // {default = true;};

    package = mkPackageOptionMD pkgs "xplr" {};

    plugins = mkOption {
      type = with types; nullOr (listOf (either package str));
      default = [];
      defaultText = literalExpression "[]";
      description = mdDoc ''
        Plugins to be added to your configuration file. Must be a package, an absolute plugin path, or string
        to be recognized by xplr.
      '';
    };

    # TODO: rename, this is the main configuration
    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = lib.mdDoc ''
        Extra xplr configuration.
      '';

      example = literalExpression ''
        require("wl-clipboard").setup {
          copy_command = "wl-copy -t text/uri-list",
          paste_command = "wl-paste",
          keep_selection = true,
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    environment = {
      # TODO: wrap the package to set config location
      systemPackages = [cfg.package];

      etc."xplr/init.lua".source = pkgs.writeText "init.lua" configFile;
    };
  };
}
