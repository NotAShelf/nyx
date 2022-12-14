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

  # enable flatpak, as well as xdgp to communicate with the host filesystems
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
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

  sound = {
    enable = true;
    mediaKeys.enable = true;
  };
}
