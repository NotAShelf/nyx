{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  env = modules.usrEnv;
  prg = env.programs;
in {
  config = mkIf prg.gaming.chess.enable {
    home.packages = with pkgs; [
      kdePackages.knights
      fairymax
      stockfish
      fishnet
    ];
  };
}
