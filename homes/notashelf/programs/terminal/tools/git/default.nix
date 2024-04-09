{
  osConfig,
  pkgs,
  ...
}: let
  inherit (osConfig) modules;
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
      zsh-forgit # zsh plugin to load forgit via `git forgit`
      gitflow
    ];

    programs.git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;

      # my credientals
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

        # disable the horrendous GUI password prompt for Git when auth fails
        core.askPass = "";

        # prefer using libsecret for storing and retrieving credientals
        credential.helper = "${pkgs.gitAndTools.gitFull}/bin/git-credential-libsecret";

        # delta is some kind of a syntax highlighting pager for git
        # it looks nice but I'd like to consider difftastic at some point
        delta = {
          enable = true;
          line-numbers = true;
          features = "decorations side-by-side navigate";
          options = {
            navigate = true;
            line-numbers = true;
            side-by-side = true;
            dark = true;
          };
        };

        branch.autosetupmerge = "true";
        pull.ff = "only";

        push = {
          default = "current";
          followTags = true;
          autoSetupRemote = true;
        };

        merge = {
          stat = "true";
          conflictstyle = "diff3";
        };

        core.whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
        color.ui = "auto";

        repack.usedeltabaseoffset = "true";

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
