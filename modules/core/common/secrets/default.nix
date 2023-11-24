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
in {
  age.identityPaths = [
    "${optionalString sys.impermanence.root.enable "/persist"}/etc/ssh/ssh_host_ed25519_key"
    "${optionalString sys.impermanence.home.enable "/persist"}/home/notashelf/.ssh/id_ed25519"
  ];

  age.secrets = mkMerge [
    {
      nix-builderKey = {
        file = "${self}/secrets/nix-builderKey.age";
        mode = "400";
        group = "root";
        owner = "root";
      };
    }

    (mkIf (builtins.elem dev.type ["desktop" "laptop" "hybrid" "lite"])
      {
        # secrets needed for peers
        spotify = {
          file = "${self}/secrets/spotify.age";
          owner = "notashelf";
          group = "users";
          mode = "400";
        };

        wg-client = {
          file = "${self}/secrets/wg-client.age";
          owner = "notashelf";
          group = "users";
          mode = "700";
        };
      })

    (mkIf (builtins.elem dev.type ["server" "hybrid"]) {
      # wireguard server peer secret
      wg-server = mkIf cfg.wireguard.enable {
        file = "${self}/secrets/wg-server.age";
      };

      # database secrets
      mongodb-secret = mkIf cfg.database.mongodb.enable {
        file = "${self}/secrets/mailserver-secret.age";
        mode = "400";
      };

      garage-env = mkIf cfg.database.garage.enable {
        file = "${self}/secrets/garage-env.age";
        mode = "400";
        owner = "garage";
        group = "garage";
      };

      # service secrets
      mkm-web = mkIf cfg.mkm.enable {
        file = "${self}/secrets/mkm-web.age";
        mode = "400";
      };

      matrix-secret = mkIf cfg.matrix.enable {
        file = "${self}/secrets/matrix-secret.age";
        owner = "matrix-synapse";
        mode = "400";
      };

      vaultwarden-env = mkIf cfg.vaultwarden.enable {
        file = "${self}/secrets/vaultwarden-env.age";
        owner = "vaultwarden";
        mode = "400";
      };

      searx-secretkey = mkIf cfg.searxng.enable {
        file = "${self}/secrets/searx-secretkey.age";
        mode = "400";
        owner = "searx";
        group = "searx";
      };

      nextcloud-secret = mkIf cfg.nextcloud.enable {
        file = "${self}/secrets/nextcloud-secret.age";
        mode = "400";
        owner = "nextcloud";
        group = "nextcloud";
      };

      attic-env = mkIf cfg.atticd.enable {
        file = "${self}/secrets/attic-env.age";
        mode = "400";
        owner = "atticd";
        group = "atticd";
      };

      forgejo-runner-token = mkIf cfg.forgejo.enable {
        file = "${self}/secrets/forgejo-runner-token.age";
        mode = "400";
        owner = "gitea-runner";
        group = "gitea-runner";
      };

      forgejo-runner-config = mkIf cfg.forgejo.enable {
        file = "${self}/secrets/forgejo-runner-config.age";
        mode = "400";
        owner = "gitea-runner";
        group = "gitea-runner";
      };

      # mailserver secrets
      mailserver-secret = mkIf cfg.mailserver.enable {
        file = "${self}/secrets/mailserver-secret.age";
        mode = "400";
      };

      mailserver-forgejo-secret = mkIf cfg.forgejo.enable {
        file = "${self}/secrets/mailserver-forgejo-secret.age";
        owner = "forgejo";
        group = "forgejo";
        mode = "400";
      };

      mailserver-vaultwarden-secret = mkIf cfg.vaultwarden.enable {
        file = "${self}/secrets/mailserver-vaultwarden-secret.age";
        owner = "vaultwarden";
        mode = "400";
      };

      mailserver-matrix-secret = mkIf cfg.matrix.enable {
        file = "${self}/secrets/mailserver-matrix-secret.age";
        owner = "matrix-synapse";
        mode = "400";
      };

      mailserver-cloud-secret = mkIf cfg.nextcloud.enable {
        file = "${self}/secrets/mailserver-cloud-secret.age";
        owner = "nextcloud";
        mode = "400";
      };

      mailserver-noreply-secret = {
        file = "${self}/secrets/mailserver-noreply-secret.age";
        owner = "mastodon";
        mode = "400";
      };
    })
  ];
}
