{pkgs, ...}: {
  imports = [
    ./bottom
    ./newsboat
    ./ranger
    ./xplr

    ./git.nix
    ./nix-shell.nix
    ./run-transient-services.nix
    ./tealdeer.nix
  ];
  programs = {
    man.enable = true;

    exa = {
      enable = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    dircolors = {
      enable = true;
      enableZshIntegration = true;
    };

    bat = {
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
  };
}
