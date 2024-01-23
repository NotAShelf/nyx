{
  config,
  lib,
  ...
}: let
  inherit (lib) optionalString;
in {
  imports = [
    ./system
  ];

  services.getty.helpLine =
    ''
      The "nixos" and "root" accounts have empty passwords.
      An ssh daemon is running. You then must set a password
      for either "root" or "nixos" with `passwd` or add an ssh key
      to /home/nixos/.ssh/authorized_keys be able to login.
      If you need a wireless connection, you may use networkmanager
      by invoking `nmcli` or `nmtui`, the ncurses interface.
    ''
    + optionalString config.services.xserver.enable ''
      Type `sudo systemctl start display-manager' to
      start the graphical user interface.
    '';

  # since we don't inherit the core module, this needs to be set here manually
  # otherwise we'll see the stateVersion error - which doesn't actually matter inside the ISO
  # but still annoying and slows down nix flake check
  system.stateVersion = "23.11";
}
