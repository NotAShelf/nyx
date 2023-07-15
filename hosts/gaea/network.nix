{
  pkgs,
  lib,
  ...
}: {
  # use networkmanager in the live environment
  networking.networkmanager.enable = lib.mkForce true;
  networking.wireless.enable = lib.mkForce false;

  # Enable SSH in the boot process.
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce ["multi-user.target"];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHRDg2lu1rXKP4OfyghP17ZVL2csnyJEJcy9Km3LQm4r notashelf@enyo"
  ];
}
