{pkgs, ...}: {
  programs.bat = {
    enable = true;
    themes = {
      Catppuccin-mocha = builtins.readFile (pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/bat/main/Catppuccin-mocha.tmTheme";
        hash = "sha256-qMQNJGZImmjrqzy7IiEkY5IhvPAMZpq0W6skLLsng/w=";
      });
    };
    config = {
      theme = "Catppuccin-mocha";
      pager = "less -FR"; # frfr
    };
  };
}
