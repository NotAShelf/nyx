{
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib; let
  programs = osConfig.modules.usrEnv.programs;

  acceptedTypes = ["laptop" "desktop" "lite"];
in {
  imports = [
    ./minecraft
    ./mangohud
    ./steam
  ];

  config = mkIf ((lib.isAcceptedDevice osConfig acceptedTypes) && programs.gaming.enable) {
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
