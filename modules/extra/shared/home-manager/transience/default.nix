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
  options = {
    enable = mkEnableOption "transience";

    user = mkOption {
      type = with types; nullOr string;
      default = null;
      description = "User to run the service as";
    };

    days = mkOption {
      type = types.int;
      default = 30;
      description = "Number of days after which files are deleted";
    };

    folders = mkOption {
      type = with types; listOf path;
      default = [];
      description = "Folders to clean up";
    };
  };

  config = {
    assertions = [
      {
        assertion = cfg.enable -> cfg.user != null;
        message = ''
          You have enabled services.transience, but have not specified your user. You must specify a "main user"
          for your system for Transience to work properly.
        '';
      }
      {
        assertion = cfg.folders != [];
        message = ''
          You have enabled services.transience, but have not specified any folders to clean up. Please specify
          at least one folder. This option defaults to an empty list, but you must specify a list of folders for
          Transience to work properly.
        '';
      }
    ];

    systemd.user.services.transience = let
      folders =
        map (
          x:
            config.home-manager.users.${cfg.user}.home.homeDirectory + "/" + x
        )
        cfg.folders;
    in {
      serviceConfig.Type = "oneshot";
      wantedBy = ["default.target"];
      script = ''
        ${builtins.concatStringsSep "\n" (map (x: "find ${
            lib.escapeShellArg x
          } -mtime +${cfg.days} -exec rm -rv {} + -depth;")
          folders)}
      '';
    };
  };
}
