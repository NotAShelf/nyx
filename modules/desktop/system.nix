{
  config,
  pkgs,
  inputs,
  ...
}: {
  environment.variables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    GTK_THEME = "Catppuccin-Frappe-Pink";
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  services = {
    gvfs.enable = true;
    dbus = {
      packages = with pkgs; [dconf];
      enable = true;
    };

    udev.packages = with pkgs; [gnome.gnome-settings-daemon];
  };

  # enable polkit
  security.polkit.enable = true;
}
