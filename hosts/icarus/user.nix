{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [../../modules/default.nix ../../home];
  config.modules = {
    programs = {
      btm.enable = true;
      neofetch.enable = true;
      vimuwu.enable = true;
    };
  };
}
