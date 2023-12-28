{
  pkgs,
  config,
  lib,
  ...
}: let
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIABG2T60uEoq4qTZtAZfSBPtlqWs2b4V4O+EptQ6S/ru notashelf@prometheus"
  ];
in {
  boot.initrd.network.ssh.authorizedKeys = keys;

  users.users.notashelf = {
    isNormalUser = true;
    shell = pkgs.zsh;
    initialPassword = "changeme";
    openssh.authorizedKeys.keys = keys;
    extraGroups =
      [
        "wheel"
        "systemd-journal"
        "audio"
        "video"
        "input"
        "plugdev"
        "lp"
        "tss"
        "power"
        "nix"
      ]
      ++ lib.ifTheyExist config [
        "network"
        "networkmanager"
        "wireshark"
        "mysql"
        "docker"
        "podman"
        "git"
        "libvirtd"
      ];
  };
}
