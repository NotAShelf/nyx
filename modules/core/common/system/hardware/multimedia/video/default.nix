{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf isx86Linux;

  sys = config.modules.system;
in {
  config = mkIf sys.video.enable {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = isx86Linux pkgs;
      };
    };

    # benchmarking tools
    environment.systemPackages = with pkgs; [
      glxinfo
      glmark2
    ];
  };
}
