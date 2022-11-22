{
  config,
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [gnome.adwaita-icon-theme];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  services = {
    udev.packages = with pkgs; [gnome.gnome-settings-daemon];
    gnome = {
      glib-networking.enable = true;
      #gnome-keyring.enable = true;
    };
    gvfs.enable = true;
  };
}
