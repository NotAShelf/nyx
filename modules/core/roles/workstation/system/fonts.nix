{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.attrsets) mapAttrs;
in {
  config = {
    fonts = {
      enableDefaultPackages = false;

      fontconfig = {
        enable = true;
        defaultFonts = let
          # fonts that should be in each font family
          # if applicable
          common = [
            "Iosevka Nerd Font"
            "Symbols Nerd Font"
            "Noto Color Emoji"
          ];
        in
          mapAttrs (_: fonts: fonts ++ common) {
            monospace = [
              "Source Code Pro Medium"
              "Source Han Mono"
            ];

            sansSerif = [
              "Lexend"
            ];

            serif = [
              "Noto Serif"
            ];

            emoji = [
              "Noto Color Emoji"
            ];
          };
      };

      fontDir = {
        enable = true;
        decompressFonts = true;
      };

      # font packages that should be installed
      packages = with pkgs; [
        # programming fonts
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
        liberation_ttf # for PDFs, Roman
        unifont

        (nerdfonts.override {fonts = ["Iosevka" "JetBrainsMono" "NerdFontsSymbolsOnly"];})
      ];
    };
  };
}
