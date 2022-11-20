{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  environment.variables = {
    BROWSER = "firefox";
    EDITOR = "nvim";
  };

  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.bluez5-experimental;
      hsphfpd.enable = true;
    };
  };

  nixpkgs.overlays = [(import ../overlays)];
  programs = {
    wireshark.enable = true;
    java.enable = true;
  };
  # enable polkit
  security.polkit.enable = true;
}
