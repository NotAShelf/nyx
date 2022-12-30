{
  config,
  pkgs,
  inputs,
  ...
}: {
  environment.variables = {
    # open links with the default browser
    BROWSER = "firefox";

    # set GTK theme as specified by the catppuccin-gtk package in 'pkgs'
    GTK_THEME = "Catppuccin-Mocha-Pink";

    # gtk applications should use filepickers specified by xdg
    GTK_USE_PORTAL = "1";
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
