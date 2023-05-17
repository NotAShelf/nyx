{
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib; let
  programs = osConfig.modules.programs;
  device = osConfig.modules.device;

  acceptedTypes = ["laptop" "desktop" "lite"];
in {
  imports = [
    ./minecraft
  ];
  config = mkIf ((builtins.elem device.type acceptedTypes) && (programs.gaming.enable)) {
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
