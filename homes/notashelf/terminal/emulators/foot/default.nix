{
  osConfig,
  lib,
  config,
  pkgs,
  inputs',
  ...
}: let
  inherit (osConfig.modules.style.colorScheme) slug;
  inherit (lib) mkIf;

  dev = osConfig.modules.device;
  acceptedTypes = ["laptop" "desktop" "hybrid" "lite"];
in {
  config = mkIf (builtins.elem dev.type acceptedTypes) {
    home.packages = with pkgs; [
      libsixel # for displaying images
    ];
    programs.foot = {
      enable = true;
      package = inputs'.nyxpkgs.packages.foot-transparent;
      server.enable = true; # broken
      settings = {
        main = {
          app-id = "foot";
          title = "foot";
          locked-title = "no";

          term = "xterm-256color";
          font = "monospace:size=14";
          pad = "16x16";
          dpi-aware = "false";
          vertical-letter-offset = "-0.75";

          notify = "notify-send -a \${app-id} -i \${app-id} \${title} \${body}";
          selection-target = "clipboard";
        };

        cursor = {
          style = "beam";
          beam-thickness = 2;
        };

        scrollback = {
          lines = 10000;
          multiplier = 3;
        };

        url = {
          launch = "xdg-open \${url}";
          label-letters = "sadfjklewcmpgh";
          osc8-underline = "url-mode";
          protocols = "http, https, ftp, ftps, file";
          uri-characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?#@!$&%*+=\"'()[]";
        };

        colors =
          {
            alpha = "0.85";
          }
          // (import ./presets/${slug}/colors.nix {inherit (config) colorscheme;});

        /*
        colors = {
          alpha = "0.85";
        };
        */

        mouse = {
          hide-when-typing = "yes";
        };
      };
    };
  };
}
