let
  # users
  notashelf = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIABG2T60uEoq4qTZtAZfSBPtlqWs2b4V4O+EptQ6S/ru notashelf@prometheus";

  # hosts
  helios = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB6M56Tp63WfuvqlL3ek3K5T0+jVC7c+nV5NfqrJM5EM root@nixos";
in {
  "spotify.age".publicKeys = [notashelf];
  "wireguard.age".publicKeys = [helios notashelf];
}
