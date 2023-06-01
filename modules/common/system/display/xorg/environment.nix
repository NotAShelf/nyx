{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  sys = config.modules.system.video;
  env = config.modules.usrEnv;
in {
  config = mkIf (sys.enable && !env.isWayland) {
    environment.etc."greetd/environments".text = ''
      ${lib.optionalString (env.desktop == "i3") "i3"}
      ${lib.optionalString (env.desktop == "awesome") "awesome"}
    '';
  };
}
