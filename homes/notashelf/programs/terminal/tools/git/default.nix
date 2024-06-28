{
  osConfig,
  pkgs,
  ...
}: let
  inherit (osConfig) modules;

  gitPackage = pkgs.gitFull;
  cfg = modules.system.programs.git;
in {
  imports = [
    ./aliases.nix
    ./ignore.nix
  ];

  config = {
    home.packages = with pkgs; [
      gist # manage github gists
      act # local github actions
      delta # pager
    ];

    programs.git = {
      enable = true;
      package = gitPackage;

      # my credentials
      userName = "NotAShelf";
      userEmail = "raf@notashelf.dev";

      # lets sign using our own key
      # this must be provided by the host
      signing = {
        key = cfg.signingKey;
        signByDefault = true;
      };

      lfs = {
        enable = true;
        skipSmudge = true;
      };

      extraConfig = {
        # I don't care about the usage of the term "master"
        # but main is easier to type, so that's that
        init.defaultBranch = "main";

        core = {
          # set delta as the main pager
          pager = "delta";

          # disable the horrendous GUI password prompt
          # for Git when SSH authentication fails
          askPass = "";

          whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
        };

        # prefer using libsecret for storing and retrieving credentials
        credential.helper = "${gitPackage}/bin/git-credential-libsecret";

        # Use readable prefixs such as (i)ndex, (w)ork tree, (c)ommit and (o)bject
        # instead of a/b/c/d for the patches.
        diff.mnemonicprefix = true;

        # delta is some kind of a syntax highlighting pager for git
        # it looks nice but I'd like to consider difftastic at some point
        delta = {
          enable = true;
          features = "decorations side-by-side navigate";
          whitespace-error-style = "22 reverse";
          side-by-side = true;
          true-color = "always";

          options = {
            dark = true;
            navigate = true;
            line-numbers = true;
            side-by-side = true;
            syntax-theme = "base16-256";
          };

          # line numbers are nice
          line-numbers = true;
          line-numbers-left-format = "";
          line-numbers-right-format = "│ ";

          # theming
          plus-style = "syntax \"#003800\"";
          minus-style = "syntax \"#3f0001\"";

          # configure decorations
          decorations = {
            commit-decoration-style = "cyan bold box ul";
            file-style = "cyan bold ul";
            file-decoration-style = "cyan bold ul";
            hunk-header-decoration-style = "cyan box ul";
          };
        };

        interactive.diffFilter = "delta --color-only --features=interactive";

        branch.autosetupmerge = "true";
        pull.ff = "only";
        color.ui = "auto";
        repack.usedeltabaseoffset = "true";

        push = {
          default = "current";
          followTags = true;
          autoSetupRemote = true;
        };

        merge = {
          conflictstyle = "diff3";
          stat = "true";
        };

        rebase = {
          autoSquash = true;
          autoStash = true;
        };

        rerere = {
          autoupdate = true;
          enabled = true;
        };

        url = {
          "https://github.com/".insteadOf = "github:";
          "ssh://git@github.com/".pushInsteadOf = "github:";
          "https://gitlab.com/".insteadOf = "gitlab:";
          "ssh://git@gitlab.com/".pushInsteadOf = "gitlab:";
          "https://aur.archlinux.org/".insteadOf = "aur:";
          "ssh://aur@aur.archlinux.org/".pushInsteadOf = "aur:";
          "https://git.sr.ht/".insteadOf = "srht:";
          "ssh://git@git.sr.ht/".pushInsteadOf = "srht:";
          "https://codeberg.org/".insteadOf = "codeberg:";
          "ssh://git@codeberg.org/".pushInsteadOf = "codeberg:";
        };
      };
    };
  };
}
