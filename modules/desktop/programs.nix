{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  environment = {
    systemPackages = [];
    sessionVariables = {
      #STEAM_EXTRA_COMPAT_TOOLS_PATHS = lib.mkForce "~/.steam/root/compatibilitytools.d";
    };
  };

  hardware = {
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };

  programs = {
    # registry for linux, thanks to gnome
    dconf.enable = true;

    # network inspection utility
    wireshark.enable = true;

    # "saying java is good because it runs on all systems is like saying
    # anal sex is good because it works on all species"
    # - sun tzu
    java.enable = true;

    # enable steam
    steam = {
      enable = true;
      # Open ports in the firewall for Steam Remote Play
      remotePlay.openFirewall = true;
      # Open ports in the firewall for Source Dedicated Server
      dedicatedServer.openFirewall = true;
      # Compatibility tools to install
      # this option is provided by ./gaming/steam.nix
      extraCompatPackages = with pkgs; [
        proton-ge
      ];
    };

    # gnome's keyring manager
    seahorse.enable = true;

    # help manage android devices via command line
    adb.enable = true;

    # networkmanager tray uility
    nm-applet.enable = false;

    # allow users to mount fuse filesystems with allow_other
    fuse.userAllowOther = true;
  };
}
