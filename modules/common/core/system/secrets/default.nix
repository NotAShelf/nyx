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
      wg-server = {
        file = "${self}/secrets/wg-server.age";
        owner = "notashelf";
        mode = "700";
        group = "users";
      };

      nix-builderKey = {
        file = "${self}/secrets/nix-builderKey.age";
        mode = "400";
      };

      matrix-secret = {
        file = "${self}/secrets/matrix-secret.age";
        owner = "matrix-synapse";
        mode = "400";
      };

      nextcloud-secret = {
        file = "${self}/secrets/nextcloud-secret.age";
        owner = "nextcloud";
        mode = "400";
      };

      mailserver-secret = {
        file = "${self}/secrets/mailserver-secret.age";
        mode = "400";
      };

      mongodb-secret = {
        file = "${self}/secrets/mailserver-secret.age";
        mode = "400";
      };
    })
  ];
}
