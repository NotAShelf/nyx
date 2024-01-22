{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services;

  inherit (cfg.hydra.settings) host port repos;
  inherit (config.networking) domain;
in {
  config = mkIf cfg.hydra.enable {
    modules.system.services = {
      nginx.enable = true;
    };

    nix.extraOptions = ''
      allowed-uris = https://github.com/ git://git.savannah.gnu.org/ https://git.sr.ht
    '';

    services = {
      hydra = {
        enable = true;
        hydraURL = "${host}:${toString port}";
        useSubstitutes = true;
        buildMachinesFiles = [];

        # notifications
        notificationSender = "hydra@notashelf.dev";
        listenHost = "localhost";
        smtpHost = "localhost";

        # allow unfree builds
        extraEnv.HYDRA_DISALLOW_UNFREE = "0";

        # github authorization and job status for each repository
        extraConfig =
          ''
            <github_authorization>
              include ${config.age.secrets.hydra-gh-token.path}
            </github_authorization>
          ''
          + (lib.concatMapStrings (repo:
            lib.optionalString repo.reportStatus
            ''
              <githubstatus>
                jobs = ${repo.name}.*
                excludeBuildFromContext = 1
                useShortContext = 1
              </githubstatus>
            '') (builtins.attrValues cfg.repos));
      };

      nginx.virtualHosts = {
        "hydra.${domain}" = {
          forceSSL = true;
          enableACME = true;
          locations = {
            "~* ^/shield/([^\\s]*)".return = "302 https://img.shields.io/endpoint?url=https://hydra.${domain}/$1/shield";
            "/".proxyPass = "http://localhost:${toString port}";
          };
        };
      };
    };

    systemd = {
      services = {
        # https://github.com/NixOS/nix/issues/4178#issuecomment-738886808
        hydra-evaluator.environment.GC_DONT_GC = "true";

        hydra-setup = let
          toSpec = {
            name,
            owner,
            ...
          }: let
            spec = {
              enabled = 1;
              hidden = false;
              description = "Declarative specification jobset automatically generated";
              checkinterval = 120;
              schedulingshares = 10000;
              enableemail = false;
              emailoverride = "";
              keepnr = 1;
              nixexprinput = "src";
              nixexprpath = "jobsets.nix";
              inputs = {
                src = {
                  type = "path";
                  value = pkgs.writeTextFile {
                    name = "src";
                    text = builtins.readFile ./jobsets.nix;
                    destination = "/jobsets.nix";
                  };
                  emailresponsible = false;
                };
                repoInfoPath = {
                  type = "path";
                  value = pkgs.writeTextFile {
                    name = "repo";
                    text = builtins.toJSON {
                      inherit name owner;
                    };
                  };
                  emailresponsible = false;
                };
                prs = {
                  type = "githubpulls";
                  value = "${owner} ${name}";
                  emailresponsible = false;
                };
              };
            };
            drv = pkgs.writeTextFile {
              name = "hydra-jobset-specification-${name}";
              text = builtins.toJSON spec;
              destination = "/spec.json";
            };
          in "${drv}";
        in {
          description = "Hydra CI setup";
          serviceConfig.Type = "oneshot";
          serviceConfig.RemainAfterExit = true;
          wantedBy = ["multi-user.target"];
          requires = ["hydra-init.service"];
          after = ["hydra-init.service"];
          environment = builtins.removeAttrs (config.systemd.services.hydra-init.environment) ["PATH"];
          script =
            ''
              PATH=$PATH:${lib.makeBinPath (with pkgs; [yq-go curl config.services.hydra.package])}
              PASSWORD="$(cat ${config.age.secrets.hydra-admin-password.path})"
              if [ ! -e ~hydra/.setup-is-complete ]; then
                hydra-create-user admin \
                  --full-name "NotAShelf" \
                  --email-address "raf@notashelf.dev" \
                  --password "$PASSWORD" \
                  --role admin
                # this is NOT a very nice way to handle it
                # but it's the only way of declaring that the setup has been complete
                touch ~hydra/.setup-is-complete
              fi

              mkdir -p /var/lib/hydra/.ssh
              cp /home/ccr/.ssh/id_rsa* /var/lib/hydra/.ssh/
              chown -R hydra:hydra /var/lib/hydra/.ssh

              mkdir -p /var/lib/hydra/queue-runner/.ssh
              cp /home/ccr/.ssh/id_rsa* /var/lib/hydra/queue-runner/.ssh/
              chown -R hydra-queue-runner:hydra /var/lib/hydra/queue-runner/.ssh

              curl --head -X GET --retry 5 --retry-connrefused --retry-delay 1 http://localhost:${port}

              CURRENT_REPOS=$(curl -s -H "Accept: application/json" http://localhost:${port} | yq ".[].name")
              DECLARED_REPOS="${lib.concatStringsSep " " (builtins.attrNames repos)}"

              curl -H "Accept: application/json" \
                -H 'Origin: http://localhost:${port}' \
                -H 'Content-Type: application/json' \
                -d "{\"username\": \"admin\", \"password\": \"$PASSWORD\"}" \
                --request "POST" localhost:${port}/login \
                --cookie-jar cookie

              for repo in $CURRENT_REPOS; do
                echo $repo
                [[ ! "$DECLARED_REPOS" =~ (\ |^)$repo(\ |$) ]] && \
                  curl -H "Accept: application/json" \
                    --request "DELETE" \
                    --cookie cookie \
                    http://localhost:${port}/project/$repo
              done
            ''
            + lib.concatMapStrings (repo: ''
              curl -H "Accept: application/json" \
                -H 'Content-Type: application/json' \
                --request "PUT" \
                localhost:${port}/project/${repo.name} \
                --cookie cookie \
                -d '{
                  "name": "${repo.name}",
                  "displayname": "${repo.name}",
                  "description": "${repo.description}",
                  "homepage": "${repo.homepage}",
                  "owner": "admin",
                  "enabled": true,
                  "visible": true,
                  "declarative": {
                    "file": "spec.json",
                    "type": "path",
                    "value": "${toSpec repo}"
                  }
                }'
            '') (builtins.attrValues repos)
            + ''
              rm cookie
            '';
        };
      };
    };
  };
}
