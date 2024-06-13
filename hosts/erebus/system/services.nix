{pkgs, ...}: {
  services = {
    gvfs.enable = true;

    udev.packages = with pkgs; [yubikey-personalization];
    pcscd.enable = true;

    autorandr.enable = true;

    xserver = {
      enable = true;
      xkb.layout = "tr";

      desktopManager.xterm.enable = false;
      displayManager = {
        lightdm.enable = false;
        gdm.enable = false;
      };
    };
  };
}
