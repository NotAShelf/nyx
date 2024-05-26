{pkgs, ...}: {
  services = {
    gvfs.enable = true;

    udev.packages = with pkgs; [yubikey-personalization];
    pcscd.enable = true;

    autorandr.enable = true;

    # auto-login as the "yubikey" user
    # in an i3-only session
    displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "yubikey";
      defaultSession = "none+i3";
    };

    xserver = {
      enable = true;
      xkb.layout = "tr";

      desktopManager = {
        xterm.enable = false;
      };

      # i3 for window management
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;

        extraPackages = with pkgs; [
          st # suckless terminal that sucks, pretty minimal though
          dmenu # application launcher
          i3status # i3 status bar
          i3lock # default i3 screen locker
        ];
      };
    };
  };
}
