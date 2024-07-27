{
  inputs',
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (osConfig.modules.style.colorScheme) slug colors;
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
      package = inputs'.nyxexprs.packages.foot-transparent;
      server.enable = false;
      settings = {
        main = {
          # window settings
          app-id = "foot";
          title = "foot";
          locked-title = "no";
          term = "xterm-256color";
          pad = "16x16 center";
          shell = "zsh";

          # notifications
          notify = "notify-send -a \${app-id} -i \${app-id} \${title} \${body}";
          selection-target = "clipboard";

          # font and font rendering
          dpi-aware = false; # this looks more readable on a laptop, but it's unreasonably large
          font = "Iosevka Nerd Font:size=14";
          font-bold = "Iosevka Nerd Font:size=14";
          vertical-letter-offset = "-0.90";
        };

        scrollback = {
          lines = 10000;
          multiplier = 3;
        };

        tweak = {
          font-monospace-warn = "no"; # reduces startup time
          sixel = "yes";
        };

        cursor = {
          style = "beam";
          beam-thickness = 2;
        };

        mouse = {
          hide-when-typing = "yes";
        };

        url = {
          launch = "xdg-open \${url}";
          label-letters = "sadfjklewcmpgh";
          osc8-underline = "url-mode";
          protocols = "http, https, ftp, ftps, file";
          uri-characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?#@!$&%*+=\"'()[]";
        };

        colors = import ./presets/${slug}/colors.nix {inherit colors;} // {alpha = "0.85";};
      };
    };
  };
}
