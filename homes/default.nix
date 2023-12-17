{
  config,
  lib,
  inputs,
  self,
  inputs',
  self',
  ...
}: let
  inherit (config) modules;
  env = modules.usrEnv;
  defaults = modules.programs.default;
in {
  home-manager = lib.mkIf env.useHomeManager {
    verbose = true;
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "old";
    extraSpecialArgs = {inherit inputs self inputs' self' defaults;};
    users = lib.genAttrs config.modules.system.users (name: ./${name});
  };
}
