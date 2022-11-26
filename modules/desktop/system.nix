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

  # enable polkit
  security.polkit.enable = true;
}
