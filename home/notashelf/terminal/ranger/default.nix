{
  pkgs,
  lib,
  osConfig,
  ...
}:
with lib; let
  device = osConfig.modules.device;
  # TODO: maybe not have a TUI file manager on desktos, when GUI does it better
  acceptedTypes = ["laptop" "desktop" "hybrid" "server" "lite"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    home.packages = with pkgs; [
      ranger
    ];

    # TODO: more file preview methods
    xdg.configFile."ranger/rc.conf".text = ''
      set preview_images true
      set preview_images_method kitty
    '';
  };
}
