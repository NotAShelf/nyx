{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  env = modules.usrEnv;
  pkg = env.packages;
in {
  config = mkIf (pkg.gui.enable && pkg.cli.wayland.enable) {
    home.packages = with pkgs; [
      wlogout
      swappy
    ];
  };
}
