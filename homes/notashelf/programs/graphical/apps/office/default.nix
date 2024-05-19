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
  config = mkIf prg.libreoffice.enable {
    home.packages = [
      prg.libreoffice.wrappedPackage
    ];
  };
}
