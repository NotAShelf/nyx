{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkDefault;
  cfg = config.modules.system.sound;
  dev = config.modules.device;
in {
  imports = [./pipewire.nix];
  config = mkIf (cfg.enable && dev.hasSound) {
    sound = {
      enable = mkDefault false; # this just enables ALSA, which we don't really care abouyt
      mediaKeys.enable = true;
    };
  };
}
