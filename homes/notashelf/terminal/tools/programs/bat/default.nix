{pkgs, ...}: let
  catppuccin = builtins.readFile (pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/bat/main/Catppuccin-mocha.tmTheme";
    hash = "sha256-qMQNJGZImmjrqzy7IiEkY5IhvPAMZpq0W6skLLsng/w=";
  });
in {
  programs.bat = {
    enable = true;
    themes = {
      Catppuccin-mocha = catppuccin;
    };
    config = {
      theme = "Catppuccin-mocha";
      pager = "less -FR"; # frfr
    };
  };
}
