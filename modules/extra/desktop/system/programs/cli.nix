{
  config,
  pkgs,
  lib,
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

    # if the system is not using wayland, then we need the non-wayland version of wine
    environment.systemPackages = lib.mkIf (!env.isWayland) [
      pkgs.wineWowPackages.stable
    ];
  };
}
