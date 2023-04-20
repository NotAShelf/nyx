{
  inputs,
  self,
  ...
}: {
  age.secrets.spotify = {
    file = "${self}/secrets/wireguard.age";
    owner = "notashelf";
    mode = "700";
    group = "users";
  };
}
