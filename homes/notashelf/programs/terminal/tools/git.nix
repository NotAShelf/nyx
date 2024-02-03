{
  osConfig,
  pkgs,
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
      userName = "NotAShelf";
      userEmail = "raf@notashelf.dev";
      signing = {
        key = cfg.signingKey;
        signByDefault = true;
      };
      ignores = [
        ".cache/"
        ".ccls-cache/"
        ".idea/"
        "*.swp"
        "*.elc"
        ".~lock*"
        "auto-save-list"
        ".direnv/"
        "node_modules"
        "result"
        "result-*"
      ];
      extraConfig = {
        init.defaultBranch = "main";

        delta = {
          enable = true;
          plus-style = "syntax ${colors.base0A}";
          minus-style = "syntax ${colors.base08}";
          line-numbers = true;
          options.navigate = true;
          features = "decorations side-by-side navigate";
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
