{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkOption literalExpression;
  inherit (lib.types) str nullOr enum mkOptionType attrsOf coercedTo;
  inherit (lib.strings) removePrefix hasPrefix isString;
  inherit (lib) serializeTheme;

  cfg = config.modules.style;

  hexColorType = mkOptionType {
    name = "hex-color";
    descriptionClass = "noun";
    description = "RGB color in hex format";
    check = x: isString x && !(hasPrefix "#" x);
  };
  colorType = attrsOf (coercedTo str (removePrefix "#") hexColorType);

  getPaletteFromScheme = slug:
    if builtins.pathExists ./palettes/${slug}.nix
    then (import ./palettes/${slug}.nix).colorscheme.palette
    else throw "The following colorscheme was imported but not found: ${slug}";
in {
  options.modules.style = {
    # choose a colorscheme
    colorScheme = {
      # "Name Of The Scheme"
      name = mkOption {
        type = nullOr (enum ["Catppuccin Mocha" "Tokyonight Storm" "Oxocarbon Dark"]);
        description = "The colorscheme that should be used globally to theme your system.";
        default = "Catppuccin Mocha";
      };

      # "name-of-the-scheme"
      slug = mkOption {
        type = str;
        default = serializeTheme "${toString cfg.colorScheme.name}"; # toString to avoid type errors if null, returns ""
        description = ''
          The serialized slug for the colorScheme you are using.

          Defaults to a lowercased version of the theme name with spaces
          replaced with hyphens.

          Must only be changed if the slug is expected to be different than
          the serialized theme name."
        '';
      };

      # this module option is taken from nix-colors by Misterio77
      # and is adapted for my personal use. Main difference is that
      # certain additional options (e.g. author or palette) have been
      # removed as they are handled by the rest of the style module.
      # <https://github.com/Misterio77/nix-colors/blob/main/module/colorscheme.nix>
      colors = mkOption {
        type = colorType;
        default = getPaletteFromScheme cfg.colorScheme.slug;
        description = ''
          An attribute set containing active colors of the system. Follows base16
          scheme by default but can be expanded to base24 or anything "above" as
          seen fit as the module option is actually not checked in any way
        '';
        example = literalExpression ''
          {
            base00 = "#002635";
            base01 = "#00384d";
            base02 = "#517F8D";
            base03 = "#6C8B91";
            base04 = "#869696";
            base05 = "#a1a19a";
            base06 = "#e6e6dc";
            base07 = "#fafaf8";
            base08 = "#ff5a67";
            base09 = "#f08e48";
            base0A = "#ffcc1b";
            base0B = "#7fc06e";
            base0C = "#14747e";
            base0D = "#5dd7b9";
            base0E = "#9a70a4";
            base0F = "#c43060";
          }
        '';
      };

      variant = mkOption {
        type = enum ["dark" "light"];
        default =
          if builtins.substring 0 1 cfg.colorScheme.colors.base00 < "5"
          then "dark"
          else "light";
        description = ''
          Whether the scheme is dark or light
        '';
      };
    };
  };
}
