{
  inputs,
  self,
  lib,
  config,
  ...
}: let
  inherit (lib) mkMerge mkIf;

  device = config.modules.device;
in {
  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
    "/home/notashelf/.ssh/id_ed25519"
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
        /*
        spotify = {
          file = "${self}/secrets/spotify.age";
          owner = "notashelf";
          mode = "700";
          group = "users";
        };
        */

        wg-client = {
          file = "${self}/secrets/wg-client.age";
          owner = "notashelf";
          mode = "700";
          group = "users";
        };
      })

    (mkIf (builtins.elem device.type ["server" "hybrid"]) {
      nix-builderKey = {
        file = "${self}/secrets/nix-builderKey.age";
        mode = "400";
        group = "users";
        owner = "notashelf";
      };

      # service secrets
      wg-server = {
        file = "${self}/secrets/wg-server.age";
      };

      mongodb-secret = {
        file = "${self}/secrets/mailserver-secret.age";
        mode = "400";
      };

      matrix-secret = {
        file = "${self}/secrets/matrix-secret.age";
        owner = "matrix-synapse";
        mode = "400";
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
    })
  ];
}
