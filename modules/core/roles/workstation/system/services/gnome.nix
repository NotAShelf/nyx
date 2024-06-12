{pkgs, ...}: {
  config = {
    services = {
      udev.packages = [pkgs.gnome.gnome-settings-daemon];
      gnome = {
        # Whether to enable gnome-keyring. This is usually necessary for storing
        # secrets for programming applications such as VSCode or GitHub desktop.
        # It is also optional to use google/nextcloud calendar.
        gnome-keyring.enable = true;
      };
    };
  };
}
