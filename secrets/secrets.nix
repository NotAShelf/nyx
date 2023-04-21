let
  # users
  notashelf = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKAYCaA6JEnTt2BI6MJn8t2Qc3E45ARZua1VWhQpSPQi";

  # hosts
  helios = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILxe8T2Bo3dbQbszpKXDo1P6r4VIdjSdvlzPw16VRKe1";

  shared = [notashelf];
in {
  "spotify.age".publicKeys = [notashelf];
  "wireguard.age".publicKeys = [helios] ++ shared;
  "wg-client.age".publicKeys = [notashelf];
}
