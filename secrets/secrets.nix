let
  notashelf = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIABG2T60uEoq4qTZtAZfSBPtlqWs2b4V4O+EptQ6S/ru notashelf@prometheus";
  hosts = ["enyo" "epimetheus" "icarus"];
in {
  "spotify.age".publicKeys = [notashelf hosts];
  "wireguard.age".publicKeys = [notashelf hosts];
}
