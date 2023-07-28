{
  config,
  pkgs,
  inputs,
  ...
}: let
  env = config.modules.usrEnv;
in {
  imports = [
    inputs.nh.nixosModules.default
  ];

  config = {
    # nh nix helper
    nh = {
      enable = true;
      clean = {
        enable = true;
        dates = "daily";
      };
    };

    programs = {
      # allow users to mount fuse filesystems with allow_other
      fuse.userAllowOther = true;

      # help manage android devices via command line
      adb.enable = true;
    };

    # determine which version of wine to be used
    # then add it to systemPackages
    environment.systemPackages = with pkgs; let
      winePackage =
        if (env.isWayland) == true
        then wineWowPackages.waylandFull
        else wineWowPackages.stableFull;
    in [winePackage];
  };
}
