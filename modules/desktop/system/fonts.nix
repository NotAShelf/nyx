{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  device = config.modules.device;
  acceptedTypes = ["server" "desktop" "laptop" "hybrid" "lite"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    fonts = {
      enableDefaultFonts = false;

      fontconfig = {
        # this fixes emoji stuff
        enable = true;

        defaultFonts = {
          monospace = [
            "Iosevka Term"
            "Iosevka Term Nerd Font Complete Mono"
            "Iosevka Nerd Font"
            "Noto Color Emoji"
          ];
          sansSerif = ["Lexend" "Noto Color Emoji"];
          serif = ["Noto Serif" "Noto Color Emoji"];
          emoji = ["Noto Color Emoji"];
        };
      };

      fontDir = {
        enable = true;
        decompressFonts = true;
      };

      # font packages that should be installed
      fonts = with pkgs; [
        corefonts
        material-icons
        material-design-icons
        roboto
        work-sans
        comic-neue
        source-sans
        twemoji-color-font
        comfortaa
        inter
        lato
        jost
        lexend
        dejavu_fonts
        iosevka-bin
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        jetbrains-mono
        emacs-all-the-icons-fonts

        (nerdfonts.override {fonts = ["Iosevka" "JetBrainsMono"];})
      ];
    };
  };
}
