{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  env = config.modules.usrEnv;
in {
  # adding dessktop items to the environment is generally handled by the programs' respective
  # nixos modules, however, to unify the desktop interface I prefer handling them manually
  # and ignoring the nixos modules entirely.
  services.xserver.displayManager = {
    startx.enable = true;
    session = [
      (mkIf env.desktops.i3.enable {
        name = "i3wm";
        manage = "desktop";
        start = ''
          ${pkgs.xorg.xinit}/bin/startx ${pkgs.i3-rounded}/bin/i3 -- vt2 &
          waitPID=$!
        '';
      })
    ];
  };
}
