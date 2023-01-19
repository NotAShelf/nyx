{pkgs, ...}: {
  # enable flatpak, as well as xdgp to communicate with the host filesystems
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
}
