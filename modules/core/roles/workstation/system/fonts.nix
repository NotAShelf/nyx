{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  dev = config.modules.device;
  acceptedTypes = ["server" "desktop" "laptop" "hybrid" "lite"];
in {
  config = mkIf (builtins.elem dev.type acceptedTypes) {
    fonts = {
      enableDefaultPackages = false;

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
      packages = with pkgs; [
        # programming fonts
        iosevka-bin
        sarasa-gothic

        # desktop fonts
        corefonts # MS fonts
        b612 # high legibility
        material-icons
        material-design-icons
        roboto
        work-sans
        comic-neue
        source-sans
        inter
        lato
        lexend
        dejavu_fonts
        noto-fonts
        noto-fonts-cjk

        # emojis
        noto-fonts-color-emoji
        twemoji-color-font
        openmoji-color
        openmoji-black

        # defaults worth keeping
        dejavu_fonts
        freefont_ttf
        gyre-fonts
        liberation_ttf
        unifont

        (nerdfonts.override {fonts = ["Iosevka" "JetBrainsMono"];})
      ];
    };
  };
}
