{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  sys = modules.system;
  prg = sys.programs;
in {
  config = mkIf prg.zathura.enable {
    xdg = {
      desktopEntries.zathura = {
        name = "zathura";
        type = "Application";
        comment = "A minimalistic PDF viewer";
        categories = ["Office" "Viewer"];
        exec = "zathura --fork %f";
        terminal = false;
        mimeType = ["application/pdf"];
      };

      configFile."zathura/catppuccin-mocha".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/zathura/main/src/catppuccin-mocha";
        hash = "sha256-/HXecio3My2eXTpY7JoYiN9mnXsps4PAThDPs4OCsAk=";
      };
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
