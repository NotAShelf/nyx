let
  notashelf = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIABG2T60uEoq4qTZtAZfSBPtlqWs2b4V4O+EptQ6S/ru notashelf@prometheus";

  prometheus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOAFtcZn42ZQBSsoPe971ROwFH5/dIxqjIRZlIBAkEMu root@prometheus";
in {
  "spotify.age".publicKeys = [notashelf prometheus];
}
