{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  dev = osConfig.modules.device;
  acceptedTypes = ["desktop" "laptop" "hybrid" "lite"];
in {
  config = mkIf (builtins.elem dev.type acceptedTypes) {
    xdg.configFile."zathura/catppuccin-mocha".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/zathura/main/src/catppuccin-mocha";
      hash = "sha256-/HXecio3My2eXTpY7JoYiN9mnXsps4PAThDPs4OCsAk=";
    };

    programs.zathura = {
      enable = true;
      extraConfig = "include catppuccin-mocha";

      options = {
        font = "Iosevka 15";
        selection-clipboard = "clipboard";
        adjust-open = "best-fit";
        pages-per-row = "1";
        scroll-page-aware = "true";
        scroll-full-overlap = "0.01";
        scroll-step = "100";
        smooth-scroll = true;
        zoom-min = "10";
        guioptions = "none";
      };
    };
  };
}
