{
  config,
  pkgs,
  inputs,
  ...
}: {
  environment.variables = {
    BROWSER = "firefox";
    GTK_THEME = "Catppuccin-Mocha-Pink";
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

  # Firefox cache on tmpfs
  fileSystems."/home/notashelf/.cache/mozilla/firefox" = {
    device = "tmpfs";
    fsType = "tmpfs";
    noCheck = true;
    options = [
      "noatime"
      "nodev"
      "nosuid"
      "size=128M"
    ];
  };
}
