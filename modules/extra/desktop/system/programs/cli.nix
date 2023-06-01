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
      # home-manager is quirky as ever, and wants this to be set in system config
      # instead of just home-manager
      zsh.enable = true;

      # run commands without installing the programs
      comma.enable = true;

      # type "fuck" to fix the last command that made you go "fuck"
      thefuck.enable = true;

      # allow users to mount fuse filesystems with allow_other
      fuse.userAllowOther = true;

      # help manage android devices via command line
      adb.enable = true;

      # "saying java is good because it runs on all systems is like saying
      # anal sex is good because it works on all species"
      # - sun tzu
      java = {
        enable = true;
        package = pkgs.jre;
      };
    };

    # if the system is not using wayland, then we need the non-wayland version of wine
    environment.systemPackages = lib.mkIf (!env.isWayland) [
      pkgs.wineWowPackages.stable
    ];
  };
}
