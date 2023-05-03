{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib; let
  device = osConfig.modules.device;
  acceptedTypes = ["desktop" "laptop" "hybrid" "lite"];

  inherit (config.colorscheme) colors;
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    programs.zathura = {
      enable = true;
      options = {
        font = "Iosevka 15";

        default-fg = "${colors.base05}";
        default-bg = "${colors.base00}";

        completion-bg = "${colors.base02}";
        completion-fg = "${colors.base05}";
        completion-highlight-bg = "#575268";
        completion-highlight-fg = "${colors.base05}";
        completion-group-bg = "${colors.base02}";
        completion-group-fg = "${colors.base0D}";

        statusbar-fg = "${colors.base05}";
        statusbar-bg = "${colors.base02}";
        statusbar-h-padding = 10;
        statusbar-v-padding = 10;

        notification-bg = "${colors.base02}";
        notification-fg = "${colors.base05}";
        notification-error-bg = "${colors.base02}";
        notification-error-fg = "${colors.base08}";
        notification-warning-bg = "${colors.base02}";
        notification-warning-fg = "#FAE3B0";
        selection-notification = true;

        inputbar-fg = "${colors.base05}";
        inputbar-bg = "${colors.base02}";

        recolor = true;
        recolor-lightcolor = "${colors.base00}";
        recolor-darkcolor = "${colors.base05}";

        index-fg = "${colors.base05}";
        index-bg = "${colors.base00}";
        index-active-fg = "${colors.base05}";
        index-active-bg = "${colors.base02}";

        render-loading-bg = "${colors.base00}";
        render-loading-fg = "${colors.base05}";

        highlight-color = "#575268";
        highlight-active-color = "#F4B8E4";
        highlight-fg = "#F4B8E4";

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
