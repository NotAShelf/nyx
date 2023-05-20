{
  inputs,
  self,
  ...
}: {
  age.secrets.wg-server = {
    file = "${self}/secrets/wg-server.age";
    owner = "notashelf";
    mode = "700";
    group = "users";
  };
}
