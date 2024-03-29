{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption;
  inherit (config) modules;

  prg = modules.system.programs;
in {
  options.modules.system.programs.gaming = {
    enable = mkEnableOption ''
      packages, services and warappers required for the device to be gaming-ready.

      Setting this option to true will also enable certain other options with
      the option to disable them explicitly.
    '';

    steam.enable = mkEnableOption "Steam client" // {default = prg.gaming.enable;};
    gamemode.enable = mkEnableOption "Feral-Interactive's Gamemode with userspace optimizations" // {default = prg.gaming.enable;};
    gamescope.enable = mkEnableOption "Gamescope compositing manager" // {default = prg.gaming.enable;};
    mangohud.enable = mkEnableOption "MangoHud overlay" // {default = prg.gaming.enable;};
  };
}
