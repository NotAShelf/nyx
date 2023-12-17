{
  osConfig,
  self,
  ...
}: let
  sys = osConfig.modules.system;
in {
  imports = [self.homeManagerModules.transience];
  services.transience = {
    enable = false;
    directories = [];
    user = sys.mainUser;
  };
}
