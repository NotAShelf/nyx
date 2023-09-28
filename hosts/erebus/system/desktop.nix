{pkgs, ...}: {
  security.sudo.wheelNeedsPassword = false;

  users.users.yubikey = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
  };

  programs.dconf.enable = true;

  services = {
    gvfs.enable = true;

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
          rofi # alternative to dmenu, usually better
          dmenu # application launcher most people use
          i3status # gives you the default i3 status bar
          i3lock # default i3 screen locker
          i3blocks # if you are planning on using i3blocks over i3status
        ];
      };
    };
  };
}
