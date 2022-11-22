{
  config,
  pkgs,
  inputs,
  ...
}: {
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  gnome = {
    glib-networking.enable = true;
    gnome-keyring.enable = true;
  };

  gvfs.enable = true;
  udev.packages = [pkgs.gnome.gnome-settings-daemon];
}
