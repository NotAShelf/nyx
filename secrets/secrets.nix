let
  # users
  notashelf = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIABG2T60uEoq4qTZtAZfSBPtlqWs2b4V4O+EptQ6S/ru notashelf@prometheus";

  # hosts
  helios = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGsKD35Pdl6MauuhbvfH3p7XM00W5GG5VQXyL+j2dtUn notashelf@helios";
in {
  "spotify.age".publicKeys = [notashelf];
  "wireguard.age".publicKeys = [helios notashelf];
}
