{
  config,
  pkgs,
  ...
}: let
  env = config.modules.usrEnv;
in {
  programs = {
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
  environment.systemPackages = [
    (
      if env.isWayland
      then pkgs.wineWowPackages.stable
      else ""
    )
  ];
}
