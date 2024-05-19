{
  osConfig,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  env = modules.usrEnv;
  prg = env.programs;

  discord-wrapped = prg.discord.package;
in {
  config = mkIf prg.discord.enable {
    home.packages = [discord-wrapped];
  };
}
