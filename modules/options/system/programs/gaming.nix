{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption;
  inherit (config) modules;

  prg = modules.system.programs;
in {
  options.modules.system.programs.gaming = {
    enable = mkEnableOption "Enable packages required for the device to be gaming-ready";
    emulation.enable = mkEnableOption "Enable programs required to emulate other platforms";
    minecraft.enable = mkEnableOption "Minecraft launcher & JDKs";
    chess.enable = mkEnableOption "Chess programs and engines" // {default = prg.gaming.enable;};
    gamescope.enable = mkEnableOption "Gamescope compositing manager" // {default = prg.gaming.enable;};
    mangohud.enable = mkEnableOption "MangoHud overlay" // {default = prg.gaming.enable;};
  };
}
