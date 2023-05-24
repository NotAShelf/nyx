{self, ...}: {
  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
    "/home/notashelf/.ssh/id_ed25519"
  ];

  age.secrets.wg-server = {
    file = "${self}/secrets/wg-server.age";
    owner = "notashelf";
    mode = "700";
    group = "users";
  };

  age.secrets.nix-builderKey = {
    file = "${self}/secrets/nix-builderKey.age";
    mode = "400";
  };

  age.secrets.matrix-secret = {
    file = "${self}/secrets/matrix-secret.age";
    owner = "matrix-synapse";
    mode = "400";
  };

  age.secrets.nextcloud-secret = {
    file = "${self}/secrets/nextcloud-secret.age";
    owner = "nextcloud";
    mode = "400";
  };

  age.secrets.mailserver-secret = {
    file = "${self}/secrets/mailserver-secret.age";
    mode = "400";
  };

  age.secrets.mongodb-secret = {
    file = "${self}/secrets/mailserver-secret.age";
    mode = "400";
  };
}
