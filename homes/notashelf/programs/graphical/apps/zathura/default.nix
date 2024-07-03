{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  env = modules.usrEnv;
  prg = env.programs;
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

      xdg.configFile."zathura/catppuccin-mocha-theme".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/zathura/main/src/catppuccin-mocha";
        hash = "sha256-POxMpm77Pd0qywy/jYzZBXF/uAKHSQ0hwtXD4wl8S2Q=";
      };

      programs.zathura = {
        enable = true;
        # <https://man.archlinux.org/man/zathurarc.5>
        options = {
          database = "sqlite"; # or plain, which is the default but also deprecated
          sandbox = "normal";
          font = "Iosevka 15";
          selection-clipboard = "clipboard";
          adjust-open = "best-fit";
          n-completion-items = 20;
          continuous-hist-save = false;

          # Zoom
          link-zoom = true;
          zoom-min = 10;

          # Page options
          pages-per-row = 1;
          page-cache-size = 25;
          page-padding = 3; # gap inbetween pages

          # Statusbar
          guioptions = "s"; # enable statusbar
          statusbar-basename = true;
          statusbar-home-tilde = true;
          statusbar-page-percent = true;
          statusbar-v-padding = 2;
          statusbar-h-padding = 6;

          # Scroll
          scroll-page-aware = true;
          scroll-full-overlap = "0.01";
          scroll-step = 100;
        };

        mappings = {
          D = "toggle_page_mode";
        };

        extraConfig = ''
          include catppuccin-mocha-theme
        '';
      };
    };
  };
}
