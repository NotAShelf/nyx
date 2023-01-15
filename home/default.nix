{
  config,
  inputs,
  self,
  ...
}: let
  usr = config.modules.system.username;
in {
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs self;
    };
    users = {
      # TODO: "base" user that will be used by default is there is no defined
      # home directory for the user
      ${usr} = ../home/${usr};
    };
  };
}
