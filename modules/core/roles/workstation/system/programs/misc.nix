{
  programs = {
    # allow users to mount fuse filesystems with allow_other
    fuse.userAllowOther = true;

    # show network usage
    bandwhich.enable = true;

    # registry for linux, thanks to gnome
    dconf.enable = true;

    # network inspection utility
    wireshark.enable = true;

    # gnome's keyring manager
    seahorse.enable = true;

    # networkmanager tray uility
    nm-applet.enable = true;
  };
}
