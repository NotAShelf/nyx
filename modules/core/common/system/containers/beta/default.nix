{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) elem;
  inherit (lib.modules) mkIf;
in {
  config = mkIf (elem "beta" config.modules.system.containers.enabledContainers) {
    containers."beta" = {
      autoStart = false;
      enableTun = true;
      ephemeral = true;
      privateNetwork = true;
      localAddress = "10.2.0.1";
      hostAddress = "10.2.0.2";
      config = _: let
        backup_path = "/var/backup/postgresql";
      in {
        system.stateVersion = "23.05";

        services.openssh.enable = true;

        users = {
          groups.beta = {};
          users = {
            root.hashedPassword = "!"; # disable root login
            beta = {
              isNormalUser = true;
              createHome = true;
              group = "beta";
            };
          };
        };

        time.timeZone = "Europe/Berlin";

        networking.interfaces = {
          eth0 = {
            useDHCP = false;
            ipv4.addresses = [
              {
                address = "192.168.6.1";
                prefixLength = 23;
              }
            ];
            ipv6.addresses = [];
          };
        };

        networking.firewall = {
          enable = true;
          allowPing = true;
          allowedTCPPorts = [5432];
        };

        services.postgresql = {
          enable = true;
          enableTCPIP = true;
          package = pkgs.postgresql;
          dataDir = "/var/db/postgresql";
          authentication = ''
            host selfoss selfoss 192.168.6.2/32 trust
          '';
          initialScript = builtins.toFile "pg_initial_script" ''
            CREATE ROLE selfoss LOGIN CREATEDB;
            CREATE DATABASE selfoss OWNER selfoss;
          '';
        };

        systemd.services.postgresql.preStart = ''
          if [ ! -d ${backup_path} ]; then
            mkdir -p ${backup_path}
            chown postgres ${backup_path}
          fi
        '';

        systemd.services.postgresql-dump = {
          path = with pkgs; [postgresql gzip];
          serviceConfig = {
            User = "root";
          };
          script = let
            db_list_command = "psql -l -t -A |cut -d'|' -f 1 |grep -v -e template0 -e template1 -e 'root=CT'";
          in ''
            ${db_list_command}
            for db in `${db_list_command}`; do
              echo "Dumping $db"
              pg_dump --format directory --file ${backup_path}/$db $db
            done
            echo "Dumping all in one gzip"
            pg_dumpall |gzip > ${backup_path}/complete_dump.sql.gz
          '';
          startAt = "daily";
        };
      };
    };
  };
}
