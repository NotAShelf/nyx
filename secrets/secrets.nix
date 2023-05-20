let
  notashelf = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIABG2T60uEoq4qTZtAZfSBPtlqWs2b4V4O+EptQ6S/ru";

  helios = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILxe8T2Bo3dbQbszpKXDo1P6r4VIdjSdvlzPw16VRKe1";
  enyo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKAYCaA6JEnTt2BI6MJn8t2Qc3E45ARZua1VWhQpSPQi";
in {
  "spotify.age".publicKeys = [enyo notashelf];
  "wg-server.age".publicKeys = [enyo helios notashelf];
  "wg-client.age".publicKeys = [enyo helios notashelf];
  "nix-builderKey.age".publicKeys = [enyo helios notashelf];
  "matrix-secret.age".publicKeys = [enyo helios notashelf];
  "nextcloud-secret.age".publicKeys = [enyo helios notashelf];
}
