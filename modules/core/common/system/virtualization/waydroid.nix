{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
in {
  config = mkIf sys.virtualization.waydroid.enable {
    environment.systemPackages = with pkgs; [
      waydroid
    ];

    virtualisation = {
      lxd.enable = sys.waydroid.enable; # TODO: make this also acceept sys.lxd.enable
      waydroid.enable = sys.waydroid.enable;
    };
  };
}
