{
  config,
  inputs,
  self,
  ...
}: {
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs;
      inherit self;
    };
    users = {
      notashelf = ../home/notashelf;
    };
  };
}
