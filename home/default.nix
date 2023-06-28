{
  config,
  inputs,
  self,
  inputs',
  self',
  ...
}: let
  usr =
    if (config.modules.system.username == null)
    then "notashelf"
    else "${config.modules.system.username}";
in {
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs self inputs' self';
    };
    users = {
      # home directory for the user
      ${usr} = ../home/${usr};
    };
  };
}
