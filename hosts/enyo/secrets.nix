{
  inputs,
  self,
  ...
}: {
  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
    "/home/notashelf/.ssh/id_ed25519"
  ];

  /*
  age.secrets.spotify = {
    file = "${self}/secrets/spotify.age";
    owner = "notashelf";
    mode = "700";
    group = "users";
  };
  */

  age.secrets.wg-client = {
    file = "${self}/secrets/wg-client.age";
    owner = "notashelf";
    mode = "700";
    group = "users";
  };

  age.secrets.nix-builderKey = {
    file = "${self}/secrets/nix-builderKey.age";
    mode = "400";
  };
}
