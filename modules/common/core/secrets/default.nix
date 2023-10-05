{
  self,
  lib,
  config,
  ...
}: let
  inherit (lib) mkMerge mkIf optionalString;

  cfg = config.modules;
  device = cfg.device;
in {
  age.identityPaths = [
    "${optionalString cfg.system.impermanence.root.enable "/persist"}/etc/ssh/ssh_host_ed25519_key"
    "${optionalString cfg.system.impermanence.home.enable "/persist"}/home/notashelf/.ssh/id_ed25519"
  ];

  age.secrets = mkMerge [
    {
      nix-builderKey = {
        file = "${self}/secrets/nix-builderKey.age";
        mode = "400";
      };
    }

    (mkIf (builtins.elem device.type ["desktop" "laptop" "hybrid" "lite"])
      {
        # secrets needed for peers
        spotify = {
          file = "${self}/secrets/spotify.age";
          owner = "notashelf";
          mode = "700";
          group = "users";
        };

        wg-client = {
          file = "${self}/secrets/wg-client.age";
          owner = "notashelf";
          mode = "700";
          group = "users";
        };

        nix-builderKey = {
          file = "${self}/secrets/nix-builderKey.age";
          mode = "400";
          group = "users";
          owner = "notashelf";
        };
      })

    (mkIf (builtins.elem device.type ["server" "hybrid"]) {
      # service secrets
      wg-server = {
        file = "${self}/secrets/wg-server.age";
      };

      mongodb-secret = {
        file = "${self}/secrets/mailserver-secret.age";
        mode = "400";
      };

      mkm-web = {
        file = "${self}/secrets/mkm-web.age";
        mode = "400";
      };

      matrix-secret = {
        file = "${self}/secrets/matrix-secret.age";
        owner = "matrix-synapse";
        mode = "400";
      };

      vaultwarden-env = {
        file = "${self}/secrets/vaultwarden-env.age";
        owner = "vaultwarden";
        mode = "400";
      };

      searx-secretkey = {
        file = "${self}/secrets/searx-secretkey.age";
        mode = "400";
        owner = "searx";
        group = "searx";
      };

      nextcloud-secret = {
        file = "${self}/secrets/nextcloud-secret.age";
        mode = "400";
        owner = "nextcloud";
        group = "nextcloud";
      };

      # mailserver secrets
      mailserver-secret = {
        file = "${self}/secrets/mailserver-secret.age";
        mode = "400";
      };

      mailserver-gitea-secret = {
        file = "${self}/secrets/mailserver-gitea-secret.age";
        owner = "git";
        group = "gitea";
        mode = "400";
      };

      mailserver-vaultwarden-secret = {
        file = "${self}/secrets/mailserver-vaultwarden-secret.age";
        owner = "vaultwarden";
        mode = "400";
      };

      mailserver-matrix-secret = {
        file = "${self}/secrets/mailserver-matrix-secret.age";
        owner = "matrix-synapse";
        mode = "400";
      };

      mailserver-cloud-secret = {
        file = "${self}/secrets/mailserver-cloud-secret.age";
        owner = "nextcloud";
        mode = "400";
      };

      mailserver-noreply-secret = {
        file = "${self}/secrets/mailserver-noreply-secret.age";
        mode = "400";
      };
    })
  ];
}
