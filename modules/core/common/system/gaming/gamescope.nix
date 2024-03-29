{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (config) modules;

  sys = modules.system;
  prg = sys.programs;
in {
  config = mkIf prg.gaming.gamescope.enable {
    programs.gamescope = {
      enable = true;
      package = pkgs.gamescope; # the default, here in case I want to override it
    };

    # workaround attempt for letting gamescope bypass YAMA LSM
    # doesn't work, but doesn't hurt to keep this here
    security.wrappers.gamescope = {
      owner = "root";
      group = "root";
      source = "${config.programs.gamescope.package}/bin/gamescope";
      capabilities = "cap_sys_ptrace,cap_sys_nice+pie";
    };
  };
}
