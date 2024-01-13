{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  prg = osConfig.modules.system.programs;
in {
  imports = [
    ./minecraft.nix
    ./mangohud.nix
    ./chess.nix
  ];

  config = mkIf prg.gaming.enable {
    home.packages = with pkgs; [
      legendary-gl # epic games launcher
      mangohud # fps counter & vulkan overlay
      lutris # alternative game launcher

      # emulators
      dolphin-emu # general console
      yuzu # switch

      # runtime
      dotnet-runtime_6 # terraria
      mono # general dotnet apps
      winetricks # wine helper utility
    ];
  };
}
