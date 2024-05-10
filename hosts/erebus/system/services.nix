{pkgs, ...}: {
  services = {
    gvfs.enable = true;

    udev.packages = with pkgs; [yubikey-personalization];
    pcscd.enable = true;

    autorandr.enable = true;
    xserver = {
      enable = true;
      layout = "tr";
      displayManager = {
        autoLogin.enable = true;
        autoLogin.user = "yubikey";
        defaultSession = "none+i3";
      };

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
