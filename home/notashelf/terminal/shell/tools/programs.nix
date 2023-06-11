{
  pkgs,
  config,
  lib,
  ...
}: {
  home = {
    packages = with pkgs; [
      gh # github command-line
      gh-cal # github activity stats in the CLI
      gist # manage github gists
      act # local github actions
      zsh-forgit # zsh plugin to load forgit via `git forgit`
      gitflow
    ];

    sessionVariables = {
      STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";
    };
  };

  programs = {
    man.enable = true;

    gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
      settings = {
        keyserver = "keys.openpgp.org";
      };
    };

    tealdeer = {
      enable = true;
      settings = {
        display = {
          compact = false;
          use_pager = true;
        };
        updates = {
          auto_update = true;
        };
      };
    };

    exa.enable = true;

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    dircolors = {
      enable = true;
      enableZshIntegration = true;
    };

    skim = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "rg --files --hidden";
      changeDirWidgetOptions = [
        "--preview 'exa --icons --git --color always -T -L 3 {} | head -200'"
        "--exact"
      ];
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
        pager = "less -FR";
      };
    };
  };
}
