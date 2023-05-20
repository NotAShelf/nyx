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
}
