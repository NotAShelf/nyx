{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  sys = config.modules.system;
  env = config.modules.usrEnv;
in {
  config = mkIf (sys.video.enable && !env.isWayland) {
    environment.etc."greetd/environments".text = ''
      ${lib.optionalString (env.desktop == "i3") "i3"}
      ${lib.optionalString (env.desktop == "awesome") "awesome"}
      zsh
    '';
  };
}
