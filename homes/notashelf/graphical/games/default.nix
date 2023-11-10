{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  prg = osConfig.modules.programs;
  dev = osConfig.modules.device;

  acceptedTypes = ["laptop" "desktop" "lite"];
in {
  imports = [
    ./minecraft
  ];

  config = mkIf ((builtins.elem dev.type acceptedTypes) && prg.gaming.enable) {
    home = {
      packages = with pkgs; [
        gamescope
        legendary-gl
        mono
        winetricks
        mangohud
        lutris
        dolphin-emu # cool emulator
        yuzu # switch emulator
        taisei # open-source touhou fan game
        # get dotnet runtime 6 - needed by terraria
        dotnet-runtime_6
      ];
    };
  };
}
