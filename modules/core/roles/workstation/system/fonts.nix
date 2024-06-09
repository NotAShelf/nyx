{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.attrsets) mapAttrs;
in {
  fonts = {
    enableDefaultPackages = false;

    fontconfig = {
      enable = true;
      hinting.enable = true;
      antialias = true;
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
          serif = ["Noto Serif"];
          sansSerif = ["Lexend"];
          emoji = ["Noto Color Emoji"];
          monospace = [
            "Source Code Pro Medium"
            "Source Han Mono"
          ];
        };
    };

    fontDir = {
      enable = true;
      decompressFonts = true;
    };

    # font packages that should be installed
    packages = with pkgs; [
      # defaults worth keeping
      dejavu_fonts
      freefont_ttf
      gyre-fonts
      liberation_ttf # for PDFs, Roman
      unifont
      roboto

      # programming fonts
      sarasa-gothic
      (nerdfonts.override {fonts = ["Iosevka" "JetBrainsMono" "NerdFontsSymbolsOnly"];})

      # desktop fonts
      corefonts # MS fonts
      b612 # high legibility
      material-icons # used in widgets and such
      material-design-icons
      work-sans
      comic-neue
      source-sans
      inter
      lato
      lexend
      dejavu_fonts
      noto-fonts
      noto-fonts-cjk-sans

      # emojis
      noto-fonts-color-emoji
      twemoji-color-font
      openmoji-color
      openmoji-black
    ];
  };
}
