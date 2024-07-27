{lib, ...}: let
  inherit (lib.strings) toLower replaceStrings;

  # serializeTheme "serializes" a theme name literal to fit uniform
  # theme "slug" format. This is used in my internal theming module to
  # identify themes by "Theme Name" and "theme-name" interchangeably.
  # "A String With Whitespaces" -> "a-string-with-whitespaces"
  serializeTheme = inputString: toLower (replaceStrings [" "] ["-"] inputString);

  # Function that takes a theme name and a source file and compiles it to CSS
  # compileSCSS "theme-name" "path/to/theme.scss" -> "$out/theme-name.css"
  # Adapted from <https://github.com/spikespaz/dotfiles>
  compileSCSS = pkgs: {
    name,
    source,
    args ? "-t expanded",
  }: let
    storePath = pkgs.runCommandLocal "compile-scss-${name}" {} ''
      mkdir -p $out
      ${lib.getExe pkgs.sassc} ${args} "${source}" > $out/"${name}".css
    '';
  in
    storePath + "/${name}.css";
in {
  inherit serializeTheme compileSCSS;
}
