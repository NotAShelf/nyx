{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  cfg = config.modules.system.sound;
  dev = config.modules.device;
in {
  imports = [
    ./pipewire

    ./realtime.nix
  ];

  config = mkIf (cfg.enable && dev.hasSound) {
    sound = {
      enable = false; # this just enables ALSA, which we don't really care abouyt
      mediaKeys.enable = true;
    };
  };
}
