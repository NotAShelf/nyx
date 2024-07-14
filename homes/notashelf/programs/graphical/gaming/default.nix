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
  imports = [
    ./minecraft.nix
    ./mangohud.nix
    ./chess.nix
  ];

  config = mkIf prg.gaming.enable {
    home.packages = with pkgs; [
      # runtime
      dotnet-runtime_6 # for running terraria manually, from binary
      mono # general dotnet apps
      winetricks # wine helper utility
    ];
  };
}
