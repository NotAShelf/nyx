{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options.modules.usrEnv.screenLock = mkOption {
    type = with types; nullOr (enum ["swaylock" "gtklock"]);
    default = "gtklock";
    description = ''
      The lockscreen module that will be enabled on the side of
      home-manager.
    '';
  };
}
