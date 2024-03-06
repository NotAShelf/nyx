{
  config,
  pkgs,
  ...
}: let
  env = config.modules.usrEnv;
in {
  # determine which version of wine to be used
  # then add it to systemPackages
  environment.systemPackages = with pkgs; let
    winePackage =
      if env.isWayland
      then wineWowPackages.waylandFull
      else wineWowPackages.stableFull;
  in [winePackage];
}
