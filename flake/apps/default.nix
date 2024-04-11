{
  perSystem = {pkgs, ...}: let
    inherit (pkgs) writeShellApplication;
  in {
    apps = {
      check-restart = {
        type = "app";
        program = writeShellApplication {
          name = "nix-flake-check";
          text = ''
            booted="$(readlink -f /run/booted-system/kernel)"
            current="$(readlink -f /run/current-system/kernel)"

            booted_kernel=$(basename "$booted")
            current_kernel=$(basename "$current")

            if [[ "$booted_kernel" != "$current_kernel" ]]; then
                echo "Restart required!"
                echo "old: $booted_kernel"
                echo "new: $current_kernel"
                exit 1
            else
                echo "system is clean.."
            fi
          '';
        };
      };

      upgrade-postgresql = {
        type = "app";
        program = let
          oldPostgres = pkgs.postgresql_15;
          newPostgres = pkgs.postgresql_16;

          dataDir = "/srv/storage/postgresql";
        in
          writeShellApplication {
            name = "nix-flake-upgrade-postgresql";
            text = ''
              if [ ! -d "${dataDir}" ]; then
                echo "Data directory does not exist! Bailing."
                exit 1
              fi

              if pgrep postgres; then
                echo "Please exit all postgres services and stop postgres!"
                systemctl list-dependencies postgresql.service --reverse
                exit 1
              fi

              export OLDDATA="${dataDir}"/"${oldPostgres.psqlSchema}"
              export NEWDATA="${dataDir}"/"${newPostgres.psqlSchema}"

              if [ "$NEWDATA" == "$OLDDATA" ]; then
                echo "Nothing to upgrade!"
                exit 1
              fi

              export OLDBIN="${oldPostgres}/bin"
              export NEWBIN="${newPostgres}/bin"


              install -d -m 0700 -o postgres -g postgres "$NEWDATA"
              cd "$NEWDATA"

              su - postgres -c "$NEWBIN/initdb -D $NEWDATA"
              su - postgres -c "$NEWBIN/pg_upgrade \
                --old-datadir $OLDDATA --new-datadir $NEWDATA \
                --old-bindir $OLDBIN --new-bindir $NEWBIN \
                $@"
            '';
          };
      };
    };
  };
}
