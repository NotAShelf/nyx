{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkOption mkEnableOption types;

  cfg = config.services.transience;
in {
  meta.maintainers = [lib.maintainers.NotAShelf];
  options.services.transience = {
    enable = mkEnableOption "transience";

    user = mkOption {
      type = with types; nullOr string;
      default = null;
      description = "The user that the directories will be relative to";
    };

    days = mkOption {
      type = types.int;
      default = 30;
      description = "Number of days after which files are deleted";
    };

    directories = mkOption {
      type = with types; listOf path;
      default = [];
      description = ''
        A list of directories that will be cleaned.

        Must be relative to the user's home directory.
      '';
    };
  };

  config = {
    assertions = [
      {
        assertion = cfg.enable -> cfg.user == null;
        message = ''
          You have enabled services.transience, but have not specified your user. You must specify a "main user"
          for your system for Transience to work properly.
        '';
      }
      {
        assertion = cfg.directories == [];
        message = ''
          You have enabled services.transience, but have not specified any directories to clean up. Please specify
          at least one folder. This option defaults to an empty list, but you must specify a list of directories for
          Transience to work properly.
        '';
      }
    ];

    systemd.user.services.transience = let
      dirs =
        map (
          x:
            config.home-manager.users.${cfg.user}.home.homeDirectory + "/" + x
        )
        cfg.directories;
    in {
      Install.wantedBy = ["default.target"];
      Service.ExecStart = ''
        ${builtins.concatStringsSep "\n" (map (x: "find ${
            lib.escapeShellArg x
          } -mtime +${cfg.days} -exec rm -rv {} + -depth;")
          dirs)}
      '';

      Unit.Description = "Clean up transient directories";
    };
  };
}
