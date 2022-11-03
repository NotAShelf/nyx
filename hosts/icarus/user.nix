{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [../../modules/default.nix ../../home];
  config.modules = {
    desktop.hyprland.enable = true;
    programs = {
      btm.enable = true;
      neofetch.enable = true;
      vimuwu.enable = true;
    };
  };
}
