{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf getExe;

  cfg = config.services.reposilite;
in {
  options.services.reposilite = {
    enable = mkEnableOption "reposilite - maven repository manager";

    package = mkOption {
      type = with types; nullOr package;
      default = null; # reposilite is not in nixpkgs
      description = "Package to install";
    };

    user = mkOption {
      type = types.str;
      default = "reposilite";
      description = "User to run reposilite as";
    };

    group = mkOption {
      type = types.str;
      default = "reposilite";
      description = "Group to run reposilite as";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Open firewall for reposilite";
    };

    settings = {
      port = mkOption {
        type = types.int;
        default = 8084;
        description = "Port to listen on";
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/reposilite";
        description = "Working directory";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.package != null;
        message = ''
          The default package is `null` as reposilite is not yet in nixpkgs.
          Please provide your own package with the {option}`services.reposilite.package` option.
        '';
      }
    ];

    environment.systemPackages = [
      cfg.package
    ];

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [
      cfg.settings.port
    ];

    users = {
      groups.reposilite = {
        name = "reposilite";
      };

      users.reposilite = {
        group = "reposilite";
        home = cfg.dataDir;
        isSystemUser = true;
        createHome = true;
      };
    };

    systemd.services."reposilite" = {
      description = "Reposilite - Maven repository";
      wantedBy = ["multi-user.target"];
      script = ''
        ${getExe cfg.package} --working-directory "${cfg.settings.dataDir}" --port "${toString cfg.port}"
      '';

      serviceConfig = {
        inherit (cfg) user group;
      };
    };
  };
}
