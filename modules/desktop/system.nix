{
  config,
  pkgs,
  inputs,
  ...
}: {
  environment.variables = {
    BROWSER = "firefox";
    GTK_THEME = "Catppuccin-Frappe-Pink";
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  services = {
    gvfs.enable = true;
  };

  # enable polkit
  security.polkit.enable = true;
}
