{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (osConfig) modules;
  inherit (osConfig.modules.style.colorScheme) colors;
  cfg = modules.system.programs.git;
in {
  home.packages = with pkgs; [
    gist # manage github gists
    act # local github actions
    zsh-forgit # zsh plugin to load forgit via `git forgit`
    gitflow
  ];

  programs = {
    # a command-line tool for github
    gh = {
      enable = true;
      gitCredentialHelper.enable = false;
      extensions = with pkgs; [
        gh-dash # dashboard with pull requests and issues
        gh-eco # explore the ecosystem
        gh-cal # contributions calender terminal viewer
      ];
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };

    git = {
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

      # construct the list of ignored files from a very large string containing
      # the list of ignored files, but in a plaintext format for my own convenience
      ignores =
        map (v: "${toString v}")
        (builtins.split "\n" (import ./ignore.nix {inherit lib;}).ignore);

      extraConfig = {
        # I don't care about the usage of the term "master"
        # but main is easier to type, so that's that
        init.defaultBranch = "main";

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

        difftastic = {
          enable = true;
          background = "dark";
          color = "auto";
          display = "side-by-side-show-both";
        };

        branch.autosetupmerge = "true";
        pull.ff = "only";

        push = {
          default = "current";
          followTags = true;
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
      lfs.enable = true;
      aliases = {
        br = "branch";
        c = "commit -m";
        ca = "commit -am";
        co = "checkout";
        d = "diff";
        df = "!git hist | peco | awk '{print $2}' | xargs -I {} git diff {}^ {}";
        edit-unmerged = "!f() { git ls-files --unmerged | cut -f2 | sort -u ; }; vim `f`";
        fuck = "commit --amend -m";
        graph = "log --all --decorate --graph";
        ps = "!git push origin $(git rev-parse --abbrev-ref HEAD)";
        pl = "!git pull origin $(git rev-parse --abbrev-ref HEAD)";
        af = "!git add $(git ls-files -m -o --exclude-standard | fzf -m)";
        st = "status";
        hist = ''
          log --pretty=format:"%Cgreen%h %Creset%cd %Cblue[%cn] %Creset%s%C(yellow)%d%C(reset)" --graph --date=relative --decorate --all
        '';
        llog = ''
          log --graph --name-status --pretty=format:"%C(red)%h %C(reset)(%cd) %C(green)%an %Creset%s %C(yellow)%d%Creset" --date=relative
        '';
      };
    };
  };
}
