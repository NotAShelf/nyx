{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (config.meta) hostname;

  cfg = config.modules.system.services;
in {
  config = mkIf cfg.forgejo.enable {
    users = {
      groups.gitea-runner = {};
      users.gitea-runner = {
        isSystemUser = true;
        createHome = true;
        home = "/var/lib/gitea-runner";
        group = "gitea-runner";
        extraGroups = ["docker"];
      };
    };

    services.gitea-actions-runner = {
      package = pkgs.forgejo-runner;
      instances = {
        "${hostname}" = {
          enable = true;

          # Identify and register this runner based on hostname
          name = "${hostname}";
          url = "https://git.notashelf.dev";
          tokenFile = config.age.secrets.forgejo-runner-token.path;

          # NOTE: changing (i.e adding or removing) labels causes your old registration token to expire
          # make sure your labels are final before deploying
          labels = [
            "debian-latest:docker://node:18-bullseye"
            "ubuntu-latest:docker://node:18-bullseye"
            "act:docker://ghcr.io/catthehacker/ubuntu:act-latest"
            #"native:host"
          ];

          settings = {
            runner = {
              # After acquiring a toker, this can be generated with act_runner to
              # create the runner configuration that includes the token file.
              # file = config.age.secrets.forgejo-runner-config.path;

              capacity = 2;
              timeout = "3h";

              # Whether skip verifying the TLS certificate of the Forgejo instance.
              insecure = false;

              # The timeout for the runner to wait for running jobs to finish when shutting down.
              # Any running jobs that haven't finished after this timeout will be cancelled.
              shutdown_timeout = "3s";

              fetch_timeout = "7s";
              fetch_interval = "3s";
            };

            cache.enabled = true;
            container = {
              network = "host";
              # Pull docker image(s) even if already present
              force_pull = false;
              # Rebuild docker image(s) even if already present
              force_rebuild = false;
            };

            # packages that'll be made available to the host
            # when the runner is configured with a host execution label.
            hostPackages = with pkgs; [
              bash
              curl
              coreutils
              wget
              gitMinimal
            ];
          };
        };
      };
    };
  };
}
