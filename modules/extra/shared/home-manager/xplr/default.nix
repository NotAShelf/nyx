{
  config,
  lib,
  pkgs,
  ...
}:
with builtins; let
  inherit (lib) types mkIf mkOption mkEnableOption mkPackageOptionMD literalExpression;

  cfg = config.programs.xplr;
  initialConfig = ''
    version = '${cfg.package.version}'
  '';
  # we provide a default version line within the configuration file, which is obtained from the package's attributes
  # merge the initial configFile, a mapped list of plugins and then the user defined configuration to obtain the final configuration
  pluginPath =
    if cfg.plugins != []
    then ("package.path=\n" + (concatStringsSep " ..\n" (map (p: ''"${p}/init.lua;"'') cfg.plugins)) + " ..\npackage.path\n")
    else "\n";
  configFile = initialConfig + pluginPath + cfg.config;
in {
  meta.maintainers = [maintainers.NotAShelf];
  options.programs.xplr = {
    enable = mkEnableOption "xplr, terminal UI based file explorer" // {default = true;};

    package = mkPackageOptionMD pkgs "xplr" {};

    plugins = mkOption {
      type = with types; nullOr (listOf (either package str));
      default = [];
      defaultText = literalExpression "[]";
      description = ''
        Plugins to be added to your configuration file. Must be a package, an absolute plugin path, or string
        to be recognized by xplr. Paths will be relative to $XDG_CONFIG_HOME/xplr/init.lua unless they are absolute.
      '';
    };

    # TODO: rename, this is the main configuration
    config = mkOption {
      type = types.lines;
      default = "";
      description = ''
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
    home.packages = [cfg.package];

    xdg.configFile."xplr/init.lua".source = pkgs.writeText "init.lua" configFile;
  };
}
