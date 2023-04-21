let
  # users
  notashelf = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIABG2T60uEoq4qTZtAZfSBPtlqWs2b4V4O+EptQ6S/ru notashelf@prometheus";

  # hosts
  helios = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILxe8T2Bo3dbQbszpKXDo1P6r4VIdjSdvlzPw16VRKe1";

  shared = [notashelf];
in {
  "spotify.age".publicKeys = [notashelf helios];
  "wireguard.age".publicKeys = [helios] ++ shared;
}
