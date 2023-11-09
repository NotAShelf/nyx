{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf getExe;

  writeServiceConfig = config:
    lib.concatStringsSep "\n" (lib.mapAttrsToList (name: value: "${name}: ${
        (
          if (lib.isBool value)
          then (lib.boolToString value)
          else (toString value)
        )
      }")
      config);

  cfg = config.services.reposilite;
in {
  options.services.reposilite = {
    enable = mkEnableOption "reposilite - maven repository manager";

    package = mkOption {
      type = with types; nullOr package;
      default = null; # reposilite is not in nixpkgs
      description = "Package to install";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/reposilite";
      description = "Working directory";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Open firewall for reposilite";
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

    settings = mkOption {
      default = {};
      description = "Settings to pass to reposilite";
      type = with types;
        submodule {
          freeformType = attrs;
          options = {
            hostname = mkOption {
              type = types.str;
              default = "0.0.0.0";
              description = "Hostname to listen on";
            };

            port = mkOption {
              type = types.int;
              default = 8080;
              description = "Port to listen on";
            };

            database = mkOption {
              type = types.str;
              default = "sqlite reposilite.db";
              description = ''
                Database configuration. Supported storage providers:
                  - mysql localhost:3306 database user password
                  - sqlite reposilite.db
                  - sqlite --temporary
                Experimental providers (not covered with tests):
                  - postgresql localhost:5432 database user password
                  - h2 reposilite
              '';
            };

            sslEnabled = mkOption {
              type = types.bool;
              default = false;
              example = true;
              description = "Support encrypted connections";
            };

            sslPort = mkOption {
              type = types.int;
              default = 443;
              description = "Port to listen on for SSL connections";
            };

            keyPath = mkOption {
              type = with types; nullOr str;
              default = "$${WORKING_DIRECTORY}/cert.pem $${WORKING_DIRECTORY}/key.pem";
              example = "${cfg.dataDir}/cert.pem ${cfg.dataDir}/key.pem";
              description = ''
                Key file to use. You can specify absolute path to the given file or use {option}`services.reposilite.dataDir` variable.
                If you want to use .pem certificate you need to specify its path next to the key path.
              '';
            };

            keyPassword = mkOption {
              type = with types; nullOr str;
              default = "";
              example = "reposilite";
              description = "Key password to use";
            };

            enforceSsl = mkOption {
              type = types.bool;
              default = false;
              description = "Redirect http traffic to https";
            };

            webThreadPoolSize = mkOption {
              type = types.addCheck types.int (x: x >= 5);
              default = 16;
              description = "Max amount of threads used by core thread pool (min: 5)";
            };

            ioThreadPool = mkOption {
              type = types.addCheck types.int (x: x >= 2);
              default = 8;
              description = "IO thread pool handles all tasks that may benefit from non-blocking IO (min: 2)";
            };

            databaseThreadPool = mkOption {
              type = types.addCheck types.int (x: x >= 1);
              default = 8;
              description = "Database thread pool manages open connections to database (min: 1)";
            };

            compressionStrategy = mkOption {
              type = types.enum ["none" "gzip"];
              default = "none";
              description = ''
                Select compression strategy used by this instance.
                Using 'none' reduces usage of CPU & memory, but ends up with higher transfer usage.
                GZIP is better option if you're not limiting resources that much to increase overall request times.
              '';
            };

            idleTimeout = mkOption {
              type = types.int;
              default = 30000;
              description = "Default idle timeout used by Jetty";
            };

            bypassExternalCache = mkOption {
              type = types.bool;
              default = true;
              description = ''
                Bypass external cache and use internal one.
                Adds cache bypass headers to each request from `/api/*` scope served by this instance
              '';
            };

            cachedLogSize = mkOption {
              type = types.int;
              default = 50;
              description = "Amount of messages stored in cached logger";
            };

            defaultFrontend = mkOption {
              type = types.bool;
              default = true;
              description = "Enable default frontend with dashboard";
            };

            basePath = mkOption {
              type = types.str;
              default = "/";
              description = ''
                Set custom base path for Reposilite instance.
                It's not recommended to mount Reposilite under custom base path
                and you should always prioritize subdomain over this option.
              '';
            };

            debugEnabled = mkOption {
              type = types.bool;
              default = false;
              description = "Debug mode";
            };
          };
        };
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [cfg.package];
      etc."reposilite/configuration.cdn" = mkIf (cfg.settings != {}) {
        text = writeServiceConfig cfg.settings;
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [cfg.settings.port];

    users = {
      groups.reposilite = {
        name = cfg.group;
      };

      users.reposilite = {
        group = cfg.user;
        home = cfg.dataDir;

        isSystemUser = true;
        createHome = true;
      };
    };

    systemd.services."reposilite" = {
      description = "Reposilite - Maven repository";
      wantedBy = ["multi-user.target"];
      script = let
        inherit (cfg) dataDir;
        staticConfig = ''--local-config "/etc/reposilite/configuration.cdn" --local-configuration-mode none'';
      in ''
        ${getExe cfg.package} --working-directory "${dataDir}" ${staticConfig}
      '';

      serviceConfig = {
        inherit (cfg) user group;

        WorkingDirectory = cfg.dataDir;
        SuccessExitStatus = 0;
        TimeoutStopSec = 10;
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
