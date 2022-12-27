{
  inputs,
  config,
  ...
}: let
  inherit (inputs.nix-colors) colorSchemes;

  # Custom colorscheme list
  default-dark = (import ./palettes/default-dark.nix).colorscheme;

  carbon-dark = (import ./palettes/carbon-dark.nix).colorscheme;
  oxocarbon-dark = (import ./palette/oxocarbon-dark.nix).colorscheme;

  # Catppuccins
  catppuccin-mocha = (import ./palettes/catppuccin-mocha.nix).colorscheme;
  catppuccin-macchiato = (import ./palettes/catppuccin-mocha.nix).colorscheme;
in {
  imports = [
    inputs.nix-colors.homeManagerModule
    ./gtk
    #./qt
  ];
  # Use the colorscheme available at github:tinted-theming/base16-schemes
  colorscheme = colorSchemes.ashes;
  #colorscheme = catppuccin-macchiato;
}
