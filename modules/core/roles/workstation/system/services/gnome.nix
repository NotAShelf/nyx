{
  pkgs,
  lib,
  ...
}: {
  config = {
    services = {
      udev.packages = with pkgs; [
        gnome.gnome-settings-daemon
      ];

      gnome = {
        glib-networking.enable = true;
        evolution-data-server.enable = true;

        # optional to use google/nextcloud calendar
        gnome-online-accounts.enable = true;

        # optional to use google/nextcloud calendar
        gnome-keyring.enable = true;

        gnome-remote-desktop.enable = lib.mkForce false;
      };
    };
  };
}
