{
  osConfig,
  lib,
  ...
}: let
  inherit (builtins) toJSON;
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  env = modules.usrEnv;
  prg = env.programs;
in {
  config = mkIf prg.element.enable {
    home.packages = [prg.element.package];

    xdg.configFile = {
      "Element/config.json".text = toJSON prg.element.settings;
    };
  };
}
