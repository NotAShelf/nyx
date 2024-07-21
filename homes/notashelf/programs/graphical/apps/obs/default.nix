{
  osConfig,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  env = modules.usrEnv;
  prg = env.programs;
in {
  config = mkIf prg.obs.enable {
    programs.obs-studio = {
      enable = true;
      package = prg.obs.package;
      plugins = prg.obs.plugins;
    };
  };
}
