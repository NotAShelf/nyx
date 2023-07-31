{
  config,
  inputs,
  self,
  inputs',
  self',
  ...
}: let
  usr =
    # if the username hasn't been defined, defaults to my own username
    # so that the home directory is loaded correctly
    if (config.modules.system.username == null)
    then "notashelf"
    else "${config.modules.system.username}";
in {
  home-manager = {
    verbose = true;
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "old";
    extraSpecialArgs = {
      inherit inputs self inputs' self';
    };
    users = {
      # home directory for the main user
      ${usr} = ./${usr};
    };
  };
}
