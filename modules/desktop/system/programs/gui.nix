{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  environment = {
    systemPackages = with pkgs; [
      # packages necessery for thunar thumbnails
      xfce.tumbler
      libgsf # odf files
      ffmpegthumbnailer
      ark # GUI archiver for thunar archive plugin
    ];
  };

  hardware = {
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };

  programs = {
    # the thunar file manager
    # we enable thunar here and add plugins instead of in systemPackages
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-media-tags-plugin
      ];
    };

    # registry for linux, thanks to gnome
    dconf.enable = true;

    # network inspection utility
    wireshark.enable = true;

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

    # networkmanager tray uility
    nm-applet.enable = true;
  };
}
