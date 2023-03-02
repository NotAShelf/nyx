{
  inputs,
  self,
  ...
}: {
  age.secrets.spotify = {
    file = "${self}/secrets/spotify.age";
    owner = "notashelf";
    mode = "700";
    group = "users";
  };
}
