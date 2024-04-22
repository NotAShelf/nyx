{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (osConfig.modules.style.colorScheme) colors;
in {
  programs.fzf = {
    enable = true;
    defaultCommand = "${lib.getBin pkgs.fd}/bin/fd --type=f --hidden --exclude=.git";
    defaultOptions = [
      "--layout=reverse" # Top-first.
      "--exact" # Substring matching by default, `'`-quote for subsequence matching.
      "--bind=alt-p:toggle-preview,alt-a:select-all"
      "--multi"
      "--no-mouse"
      "--info=inline"

      # Style and widget layout
      "--ansi"
      "--with-nth=1.."
      "--pointer=' '"
      "--pointer=' '"
      "--header-first"
      "--border=rounded"
    ];

    colors = {
      "preview-bg" = "-1";
      "gutter" = "-1";
      "bg" = "-1";
      "bg+" = "-1";
      "fg" = "#${colors.base04}";
      "fg+" = "#${colors.base06}";
      "hl" = "#${colors.base0D}";
      "hl+" = "#${colors.base0D}";
      "header" = "#${colors.base0D}";
      "info" = "#${colors.base0A}";
      "pointer" = "#${colors.base0C}";
      "marker" = "#${colors.base0C}";
      "prompt" = "#${colors.base0A}";
      "spinner" = "#${colors.base0C}";
      "preview-fg" = "#${colors.base0D}";
    };

    enableZshIntegration = false; # we handle this ourselves
    enableBashIntegration = false; # I don't think I've ever used fzf with bash
  };
}
