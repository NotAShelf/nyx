{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  env = osConfig.modules.usrEnv;
in {
  imports = [./config.nix];
  config = mkIf env.desktops.sway.enable {
    wayland.windowManager.sway = {
      enable = true;
      package = pkgs.swayfx;
    };
  };
}
