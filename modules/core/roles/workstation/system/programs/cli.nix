{
  inputs,
  config,
  pkgs,
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
      package = pkgs.nh;
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

      # show network usage
      bandwhich.enable = true;

      # "saying java is good because it runs on all systems is like saying
      # anal sex is good because it works on all species"
      # - sun tzu
      java = {
        enable = true;
        package = pkgs.jre;
      };
    };

    # determine which version of wine to be used
    # then add it to systemPackages
    environment.systemPackages = with pkgs; let
      winePackage =
        if env.isWayland
        then wineWowPackages.waylandFull
        else wineWowPackages.stableFull;
    in [winePackage];
  };
}
