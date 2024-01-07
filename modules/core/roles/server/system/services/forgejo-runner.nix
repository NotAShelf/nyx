{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.modules.system.services;

  # construct each runner using the mkRunner function
  # you can pass additional configuration options in the instance submodule
  # it'll be merged to the below configuration
  mkRunner = {
    name,
    settings,
  }:
    {
      enable = true;
      inherit name;

      url = "https://git.notashelf.dev";

      # NOTE: changing (i.e adding or removing) labels causes your old registration token to expire
      # make sure your labels are final before deploying
      labels = [
        "debian-latest:docker://node:18-bullseye"
        "ubuntu-latest:docker://node:18-bullseye"
        "act:docker://ghcr.io/catthehacker/ubuntu:act-latest"
        #"native:host"
      ];
    }
    // settings;
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
      package = pkgs.forgejo-actions-runner;
      instances = {
        "runner-01" = mkRunner {
          name = "runner-01";
          settings = {
            tokenFile = config.age.secrets.forgejo-runner-token.path;
            settings = {
              capacity = 4;
              container.network = "host";
              cache.enabled = true;
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
