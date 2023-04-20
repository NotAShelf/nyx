{
  inputs,
  self,
  ...
}: {
  age.secrets.wireguard = {
    file = "${self}/secrets/wireguard.age";
    owner = "notashelf";
    mode = "700";
    group = "users";
  };
}

