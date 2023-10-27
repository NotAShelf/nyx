{config, ...}: {
  home = {
    sessionVariables = {
      STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";
    };
  };

  programs.starship = let
    inherit (import ./elements.nix) elements;
    elemsConcatted = builtins.concatStringsSep "" elements;
  in {
    enable = true;

    settings = {
      add_newline = false;
      scan_timeout = 3;

      format = "$hostname$username[ ](bold green) $hosntame$directory$vcsh$fossil_branch$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$nix_shell${elemsConcatted}\n$character";

      # configure specific elements
      character = {
        error_symbol = "[](bold red)";
        success_symbol = "[](bold green)";
        vicmd_symbol = "[](bold yellow)";
        format = "$symbol [|](bold bright-black) ";
      };

      git_commit.commit_hash_length = 7;
      line_break.disabled = false;

      hostname = {
        format = "@[$hostname](bold blue) "; # the whitespace at the end is actually important
        ssh_only = true;
        disabled = false;
      };

      # language configurations
      lua.symbol = "[](blue) ";
      python.symbol = "[](blue) ";
      nix_shell.symbol = "[](blue) ";
      rust.symbol = "[](red) ";
      package.symbol = "📦  ";
    };
  };
}
