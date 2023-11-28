let
  # users
  notashelf = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIABG2T60uEoq4qTZtAZfSBPtlqWs2b4V4O+EptQ6S/ru";

  # hosts
  helios = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB8XojSEerAwKwXUPIZASZ5sXPPT7v/26ONQcH9zIFK+";
  enyo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKAYCaA6JEnTt2BI6MJn8t2Qc3E45ARZua1VWhQpSPQi";
  hermes = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEPShBrtrNRNaYUtIWhn0RHDr759mMcfZjqjJRAfCnWU";
  icarus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHWh3pRk2edQkELicwkYFVGKy90sFlluECfTasjCQr1m";
  leto = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCvw6R8RS6e1tpf5rnFMv+xWQsNk082wRlwTaaFKmIrx0iotP1nE5Tux+uKhx1u71se3LwtzvxvaAcZgqnowq1tZWCeqDWcz7uanDogsmjc+vS54P//gmhWAeAX9ClHIdFBpZSc1+R+aKws9KjJQBOUZi9/07f77AjmxbSDMVeCv5mMF++WjKlE8oJKaa2lLyhxeF5mr2GoNfCkF7FknTrX+mZ6EqW3g0FHHbhqCim4fdTZUberja/W4m2UwWXewgfTUVNowONB8035/BWbBwnxK8i2f2cqdXqF1SVN5SK14Bq7etIc0lJVmLcPz+R6kZPWu6NBF0D92eGBozdzCuJWy/NO/Y6G5Y2tSdFAkkTlpJPM4PA4pQP2XHuohgYOceMtDb4N75ZC10uNiDR/DnwVIa1dzjFQ1ZMfgZ94EwGd9Vy0oklQGrbkAXHA+DPFnc3PTuRUyMgOavI2RxIgYT8LQYWpxc0wGRiBXY/CqbaKSWERxxSlu4Js/0MfRq0GVyxAqE1Lg6C4oodXB4a6j/0/nF4jWLMxVTx3LH4hljV9o1JKbf3sApv9gUoF4Kwv3dv19iJhjcQLF9gKV8qCeIRC5Dp6cV0XI/IhmAMp5rCOVBqIUxYPWJBZYCatxS3gwVGqQPo/X6OLx35C5N5IVRVYd+D59s1crKTDvkZpGH1zOw==";

  # aliases
  servers = [helios icarus leto];
  workstations = [enyo hermes icarus];

  # helpers
  mkGeneric = list: list ++ [notashelf];
in {
  # core system secrets
  "spotify.age".publicKeys = mkGeneric workstations;
  "nix-builderKey.age".publicKeys = mkGeneric (workstations ++ servers);
  "wg-client.age".publicKeys = mkGeneric (workstations ++ servers);

  # service specific secrets
  "matrix-secret.age".publicKeys = mkGeneric servers;
  "nextcloud-secret.age".publicKeys = mkGeneric servers;
  "mongodb-secret.age".publicKeys = mkGeneric servers;
  "mkm-web.age".publicKeys = mkGeneric servers;
  "vaultwarden-env.age".publicKeys = mkGeneric servers;
  "wg-server.age".publicKeys = mkGeneric servers;
  "searx-secretkey.age".publicKeys = mkGeneric servers;
  "garage-env.age".publicKeys = mkGeneric servers;
  "forgejo-runner-token.age".publicKeys = mkGeneric servers;
  "forgejo-runner-config.age".publicKeys = mkGeneric servers;
  "harmonia-privateKey.age".publicKeys = mkGeneric servers;
  "attic-env.age".publicKeys = mkGeneric servers;

  # secrets for specific mailserver accounts
  "mailserver-secret.age".publicKeys = mkGeneric servers;
  "mailserver-forgejo-secret.age".publicKeys = mkGeneric servers;
  "mailserver-vaultwarden-secret.age".publicKeys = mkGeneric servers;
  "mailserver-matrix-secret.age".publicKeys = mkGeneric servers;
  "mailserver-cloud-secret.age".publicKeys = mkGeneric servers;
  "mailserver-noreply-secret.age".publicKeys = mkGeneric servers;
}
