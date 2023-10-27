{
  osConfig,
  inputs,
  ...
}: let
  # inherit (inputs.nix-colors) colorSchemes;
  inherit (osConfig.modules.style.colorScheme) slug;
in {
  imports = [
    inputs.nix-colors.homeManagerModule
    ./gtk.nix
    ./qt.nix
    ./global.nix
  ];
  # Use the colorscheme available at github:tinted-theming/base16-schemes
  # colorscheme = colorSchemes.ashes;

  # use the self-declared color scheme from palettes directory
  inherit ((import ./palettes/${slug}.nix)) colorscheme;
}
