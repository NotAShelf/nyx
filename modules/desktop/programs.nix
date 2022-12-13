{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    gnome.gnome-control-center
    gnome.gnome-calendar
  ];

  hardware = {
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };

  programs = {
    wireshark.enable = true;
    java.enable = true;
    steam.enable = true;
    seahorse.enable = true;
    adb.enable = true;
    nm-applet.enable = true;
  };
}
