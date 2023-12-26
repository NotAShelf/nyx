{lib}: let
  # function to generate theme slugs from theme names
  # "A String With Whitespaces" -> "a-string-with-whitespaces"
  serializeTheme = inputString: lib.strings.toLower (builtins.replaceStrings [" "] ["-"] inputString);
in {
  inherit serializeTheme;
}
