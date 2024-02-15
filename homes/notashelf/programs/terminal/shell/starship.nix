{
  config,
  lib,
  ...
}: let
  inherit (builtins) map;
  inherit (lib.strings) concatStrings;
in {
  home = {
    sessionVariables = {
      STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";
    };
  };

  programs.starship = let
    elemsConcatted = concatStrings (
      map (s: "\$${s}") [
        "hostname"
        "username"
        "directory"
        "shell"
        "nix_shell"
        "git_branch"
        "git_commit"
        "git_state"
        "git_status"
        "jobs"
        "cmd_duration"
      ]
    );
  in {
    enable = true;

    settings = {
      scan_timeout = 2;
      command_timeout = 2000; # nixpkgs makes starship implode with lower values
      add_newline = false;
      line_break.disabled = false;

      format = "${elemsConcatted}\n$character";

      hostname = {
        ssh_only = true;
        disabled = false;
        format = "@[$hostname](bold blue) "; # the whitespace at the end is actually important
      };

      # configure specific elements
      character = {
        error_symbol = "[](bold red)";
        success_symbol = "[](bold green)";
        vicmd_symbol = "[](bold yellow)";
        format = "$symbol [|](bold bright-black) ";
      };

      username = {
        format = "[$user]($style) in ";
      };

      directory = {
        truncation_length = 2;

        # removes the read_only symbol from the format, it doesn't play nicely with my folder icon
        format = "[ ](bold green) [$path]($style) ";

        # the following removes tildes from the path, and substitutes some folders with shorter names
        substitutions = {
          "~/Dev" = "Dev";
          "~/Documents" = "Docs";
        };
      };

      # git
      git_commit.commit_hash_length = 7;
      git_branch.style = "bold purple";
      git_status = {
        style = "red";
        ahead = "⇡ ";
        behind = "⇣ ";
        conflicted = "!";
        renamed = "»";
        deleted = "✘ ";
        diverged = "󱡷 ";
        modified = "!";
        stashed = "$";
        staged = "+";
        untracked = "";
      };

      # language configurations
      # the whitespaces at the end *are* necessary for proper formatting
      lua.symbol = "[ ](blue) ";
      python.symbol = "[ ](blue) ";
      rust.symbol = "[ ](red) ";
      nix_shell.symbol = "[󱄅 ](blue) ";
      golang.symbol = "[󰟓 ](blue)";
      c.symbol = "[ ](black)";
      nodejs.symbol = "[󰎙 ](yellow)";

      package.symbol = "📦 ";
    };
  };
}
