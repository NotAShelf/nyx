{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  environment.variables = {
    BROWSER = "firefox";
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
}
