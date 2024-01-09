{
  pkgs,
  lib,
  osConfig,
  config,
  ...
}: let
  device = osConfig.modules.device;
  # TODO: maybe not have a TUI file manager on desktops, when GUI does it better
  acceptedTypes = ["laptop" "desktop" "hybrid" "server" "lite"];
  inherit (lib.strings) optionalString;
in {
  config = lib.mkIf (builtins.elem device.type acceptedTypes) {
    home.packages = with pkgs; [
      ranger
    ];

    # TODO: more file preview methods
    xdg.configFile."ranger/rc.conf".text = ''
      set preview_images true
      ${(optionalString config.programs.kitty.enable "set preview_images_method kitty")}
    '';
  };
}
