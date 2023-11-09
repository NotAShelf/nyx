{
  config,
  lib,
  pkgs,
  ...
}:
with builtins; let
  inherit (lib) types mkIf mkOption mkEnableOption mkPackageOptionMD literalExpression;

  cfg = config.programs.vifm;
in {
  meta.maintainers = [maintainers.NotAShelf];
  options.programs.vifm = {
    enable = mkEnableOption "vifm, file manager with curses interface, which provides Vim-like environment for managing objects within file systems";

    package = mkPackageOptionMD pkgs "vifm" {};

    config = mkOption {
      type = types.lines;
      default = "";
      description = "Vifm configuration to be written in vifmrc";

      example = literalExpression ''
        " vim:ft=vifm
        set vicmd="nvim"
        set runexec
      '';
    };

    extraConfigFiles = mkOption {
      type = with types; listOf str;
      default = [];
      example = ["~/.config/vifm/vifmrc.local"];
      description = ''
        Extra vifm configuration files to be sourced in vifmrc

        Can be an absolute path, or a path relative to `$XDG_CONFIG_HOME/vifm`
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.configFile."vifm/vifmrc".source = pkgs.writeText "vifmrc" (
      (lib.concatLines (lib.forEach cfg.extraConfigFiles (x: "source ${x}")))
      + cfg.config
    );
  };
}
