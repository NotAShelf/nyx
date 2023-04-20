{pkgs, ...}: {
  users.users.notashelf = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
      "systemd-journal"
      "audio"
      "wireshark"
      "video"
      "input"
      "plugdev"
      "lp"
      "networkmanager"
      "libvirtd"
      "tss"
      "power"
      "nix"
      "gitea"
    ];
    uid = 1001;
    shell = pkgs.zsh;
    initialPassword = "changeme";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIABG2T60uEoq4qTZtAZfSBPtlqWs2b4V4O+EptQ6S/ru notashelf@prometheus"
    ];
  };
}
