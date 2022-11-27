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
    bluetooth = {
      enable = true;
      package = pkgs.bluez5-experimental;
      hsphfpd.enable = true;
    };
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };

  programs = {
    wireshark.enable = true;
    java.enable = true;
    steam.enable = true;
  };
}
