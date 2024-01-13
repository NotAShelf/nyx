{lib}: let
  # function to generate theme slugs from theme names
  # "A String With Whitespaces" -> "a-string-with-whitespaces"
  serializeTheme = inputString: lib.strings.toLower (builtins.replaceStrings [" "] ["-"] inputString);

  # a function that takes a theme name and a source file and compiles it to CSS
  # compileSCSS "theme-name" "path/to/theme.scss" -> "$out/theme-name.css"
  # adapted from <https://github.com/spikespaz/dotfiles>
  compileSCSS = pkgs: {
    name,
    source,
    args ? "-t expanded",
  }: "${
    pkgs.runCommandLocal name {} ''
      mkdir -p $out
      ${lib.getExe pkgs.sassc} ${args} '${source}' > $out/${name}.css
    ''
  }/${name}.css";
in {
  inherit serializeTheme compileSCSS;
}
