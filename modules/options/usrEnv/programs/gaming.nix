{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption;
  inherit (config) modules;

  sys = modules.system;
  prg = sys.programs;
in {
  options.modules.usrEnv.programs.gaming = {
    enable = mkEnableOption "userspace gaming programs" // {default = prg.gaming.enable;};
    emulation.enable = mkEnableOption "programs required to emulate other platforms" // {default = prg.gaming.enable;};
    minecraft.enable = mkEnableOption "Minecraft launcher & JDKs" // {default = prg.gaming.enable;};
    chess.enable = mkEnableOption "Chess programs and engines" // {default = prg.gaming.enable;};
    mangohud.enable = mkEnableOption "MangoHud overlay" // {default = prg.gaming.enable;};
  };
}
