{
  self,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkMerge optionalString;

  sys = config.modules.system;
  dev = config.modules.device;
  cfg = sys.services;

  mkSecret = enableCondition: {
    file,
    owner ? "root",
    group ? "root",
    mode ? "400",
  }:
    mkIf enableCondition {
      file = "${self}/secrets/${file}";
      inherit group owner mode;
    };
in {
  age.identityPaths = [
    "${optionalString sys.impermanence.root.enable "/persist"}/etc/ssh/ssh_host_ed25519_key"
    "${optionalString sys.impermanence.home.enable "/persist"}/home/notashelf/.ssh/id_ed25519"
  ];

  age.secrets = mkMerge [
    {
      # TODO: system option for declaring host as a potential builder
      nix-builderKey = mkSecret true {
        file = "common-nix-builder.age";
      };
    }

    (mkIf (builtins.elem dev.type ["desktop" "laptop" "hybrid" "lite"])
      {
        # secrets needed for peers
        spotify-secret = mkSecret config.modules.programs.spotify.enable {
          file = "client-spotify.age";
          owner = "notashelf";
          group = "users";
          mode = "400";
        };

        wg-client = mkSecret true {
          file = "client-wg.age";
          owner = "notashelf";
          group = "users";
          mode = "700";
        };

        tailscale-client = mkSecret true {
          file = "client-tailscale.age";
          owner = "notashelf";
          group = "users";
          mode = "400";
        };
      })

    (mkIf (builtins.elem dev.type ["server" "hybrid"]) {
      # database secrets
      mongodb-secret = mkSecret cfg.database.mongodb.enable {
        file = "db-mongodb.age";
      };

      garage-env = mkSecret cfg.database.garage.enable {
        file = "db-garage.age";
        mode = "400";
        owner = "garage";
        group = "garage";
      };

      # service secrets
      wg-server = mkSecret cfg.networking.wireguard.enable {
        file = "service-wg.age";
      };

      mkm-web = mkSecret cfg.mkm.enable {
        file = "service-mkm-web.age";
        mode = "400";
      };

      matrix-secret = mkSecret cfg.matrix.enable {
        file = "service-matrix.age";
        owner = "matrix-synapse";
        mode = "400";
      };

      vaultwarden-env = mkSecret cfg.vaultwarden.enable {
        file = "service-vaultwarden.age";
        owner = "vaultwarden";
        mode = "400";
      };

      searx-secretkey = mkSecret cfg.searxng.enable {
        file = "service-searx.age";
        mode = "400";
        owner = "searx";
        group = "searx";
      };

      nextcloud-secret = mkSecret cfg.nextcloud.enable {
        file = "service-nextcloud.age";
        mode = "400";
        owner = "nextcloud";
        group = "nextcloud";
      };

      attic-env = mkSecret cfg.bincache.atticd.enable {
        file = "service-attic.age";
        mode = "400";
        owner = "atticd";
        group = "atticd";
      };

      harmonia-privateKey = mkSecret cfg.bincache.harmonia.enable {
        file = "service-harmonia.age";
        mode = "770";
        owner = "harmonia";
        group = "harmonia";
      };

      forgejo-runner-token = mkSecret cfg.forgejo.enable {
        file = "service-forgejo-runner-token.age";
        mode = "400";
        owner = "gitea-runner";
        group = "gitea-runner";
      };

      forgejo-runner-config = mkSecret cfg.forgejo.enable {
        file = "service-forgejo-runner-config.age";
        mode = "400";
        owner = "gitea-runner";
        group = "gitea-runner";
      };

      # mailserver secrets
      mailserver-secret = mkSecret cfg.mailserver.enable {
        file = "mailserver.age";
        mode = "400";
      };

      mailserver-forgejo-secret = mkSecret cfg.forgejo.enable {
        file = "mailserver-forgejo.age";
        owner = "forgejo";
        group = "forgejo";
        mode = "400";
      };

      mailserver-vaultwarden-secret = mkSecret cfg.vaultwarden.enable {
        file = "mailserver-vaultwarden.age";
        owner = "vaultwarden";
        mode = "400";
      };

      mailserver-matrix-secret = mkSecret cfg.matrix.enable {
        file = "mailserver-matrix.age";
        owner = "matrix-synapse";
        mode = "400";
      };

      mailserver-cloud-secret = mkSecret cfg.nextcloud.enable {
        file = "mailserver-cloud.age";
        owner = "nextcloud";
        mode = "400";
      };

      mailserver-noreply-secret = mkSecret cfg.mastodon.enable {
        file = "mailserver-noreply.age";
        owner = "mastodon";
        mode = "400";
      };
    })
  ];
}
