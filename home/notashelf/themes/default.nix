{
  inputs,
  config,
  ...
}: let
  inherit (inputs.nix-colors) colorSchemes;

  # Custom colorscheme list
  default-dark = (import ./palettes/default-dark.nix).colorscheme;

  carbon-dark = (import ./palettes/carbon-dark.nix).colorscheme;
  oxocarbon-dark = (import ./palettes/oxocarbon-dark.nix).colorscheme;
  decay-dark = (import ./palettes/decay-dark.nix).colorscheme;

  noelle = (import ./palettes/noelle.nix).colorscheme;

  # Catppuccins
  catppuccin-mocha = (import ./palettes/catppuccin-mocha.nix).colorscheme;
  catppuccin-macchiato = (import ./palettes/catppuccin-mocha.nix).colorscheme;
  catppuccin-frappe = (import ./palettes/catppuccin-frappe.nix).coloscheme;
in {
  imports = [
    inputs.nix-colors.homeManagerModule
    ./gtk.nix
    ./qt.nix
  ];
  # Use the colorscheme available at github:tinted-theming/base16-schemes
  #colorscheme = colorSchemes.ashes;

  # use the self-declared color scheme from palettes directory
  colorscheme = catppuccin-mocha;
}
