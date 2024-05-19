{
  osConfig,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  sys = modules.system;
  prg = sys.programs;
in {
  config = mkIf prg.obs.enable {
    programs.obs-studio = {
      enable = true;
      package = prg.obs.package;
      plugins = prg.obs.plugins;
    };
  };
}
