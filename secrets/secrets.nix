let
  notashelf = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIABG2T60uEoq4qTZtAZfSBPtlqWs2b4V4O+EptQ6S/ru";

  helios = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB8XojSEerAwKwXUPIZASZ5sXPPT7v/26ONQcH9zIFK+";
  enyo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKAYCaA6JEnTt2BI6MJn8t2Qc3E45ARZua1VWhQpSPQi";
  hermes = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEPShBrtrNRNaYUtIWhn0RHDr759mMcfZjqjJRAfCnWU";
in {
  "spotify.age".publicKeys = [enyo hermes notashelf];
  "wg-server.age".publicKeys = [enyo helios notashelf];
  "wg-client.age".publicKeys = [enyo helios hermes notashelf];
  "nix-builderKey.age".publicKeys = [enyo helios hermes notashelf];
  "matrix-secret.age".publicKeys = [enyo helios notashelf];
  "nextcloud-secret.age".publicKeys = [enyo helios notashelf];
  "mailserver-secret.age".publicKeys = [enyo helios notashelf];
  "mongodb-secret.age".publicKeys = [enyo helios notashelf];
}
