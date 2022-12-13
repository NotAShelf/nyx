{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.wezterm
  ];
  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };
}
