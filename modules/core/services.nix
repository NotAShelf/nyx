{
  config,
  pkgs,
  lib,
  ...
}: {
  services = {
    dbus = {
      enable = true;
      packages = [pkgs.dconf];
    };

    udev.packages = [pkgs.gnome.gnome-settings-daemon];

    resolved.enable = true;

    journald.extraConfig = ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';

    gvfs.enable = true;
    gnome = {
      glib-networking.enable = true;
      gnome-keyring.enable = true;
    };

    lorri.enable = true;
    udisks2.enable = true;
    fstrim.enable = true;

    # enable and secure ssh
    openssh = {
      enable = lib.mkDefault true;
      permitRootLogin = "no";
    };

    upower.enable = true;
  };
}
