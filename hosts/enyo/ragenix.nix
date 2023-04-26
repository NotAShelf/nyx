{
  inputs,
  self,
  ...
}: {
  
  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  age.secrets.spotify = {
    file = "${self}/secrets/spotify.age";
    owner = "notashelf";
    mode = "700";
    group = "users";
  };

  age.secrets.wg-client = {
    file = "${self}/secrets/wg-client.age";
    owner = "notashelf";
    mode = "700";
    group = "users";
  };
}
