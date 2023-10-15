let
  # users
  notashelf = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIABG2T60uEoq4qTZtAZfSBPtlqWs2b4V4O+EptQ6S/ru";

  # hosts
  helios = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB8XojSEerAwKwXUPIZASZ5sXPPT7v/26ONQcH9zIFK+";
  enyo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKAYCaA6JEnTt2BI6MJn8t2Qc3E45ARZua1VWhQpSPQi";
  hermes = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEPShBrtrNRNaYUtIWhn0RHDr759mMcfZjqjJRAfCnWU";
  icarus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHWh3pRk2edQkELicwkYFVGKy90sFlluECfTasjCQr1m";
in {
  # core system secrets
  "spotify.age".publicKeys = [enyo hermes icarus notashelf];
  "nix-builderKey.age".publicKeys = [enyo helios hermes icarus notashelf];
  "wg-client.age".publicKeys = [enyo helios hermes icarus notashelf];

  # service specific secrets
  "matrix-secret.age".publicKeys = [enyo helios notashelf];
  "nextcloud-secret.age".publicKeys = [enyo helios notashelf];
  "mongodb-secret.age".publicKeys = [enyo helios notashelf];
  "mkm-web.age".publicKeys = [enyo helios notashelf];
  "vaultwarden-env.age".publicKeys = [enyo helios notashelf];
  "wg-server.age".publicKeys = [enyo helios notashelf];
  "searx-secretkey.age".publicKeys = [enyo helios notashelf];

  # secrets for specific mailserver accounts
  "mailserver-secret.age".publicKeys = [enyo helios notashelf];
  "mailserver-forgejo-secret.age".publicKeys = [enyo helios notashelf];
  "mailserver-vaultwarden-secret.age".publicKeys = [enyo helios notashelf];
  "mailserver-matrix-secret.age".publicKeys = [enyo helios notashelf];
  "mailserver-cloud-secret.age".publicKeys = [enyo helios notashelf];
  "mailserver-noreply-secret.age".publicKeys = [enyo helios notashelf];
}
