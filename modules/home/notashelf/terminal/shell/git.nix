{...}: {
  programs.git = {
    enable = true;
    userName = "NotAShelf";
    userEmail = "itsashelf@gmail.com";
    signing = {
      key = "419DBDD3228990BE";
      signByDefault = true;
    };
    ignores = [
      ".cache/"
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
      init = {defaultBranch = "main";};
      delta = {
        syntax-theme = "Nord";
        plus-style = "syntax #a6d189";
        minus-style = "syntax #e78284";
        line-numbers = true;
      };
      branch.autosetupmerge = "true";
      push.default = "current";
      merge.stat = "true";
      core.whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
      repack.usedeltabaseoffset = "true";
      pull.ff = "only";
      rebase = {
        autoSquash = true;
        autoStash = true;
      };
      rerere = {
        autoupdate = true;
        enabled = true;
      };
    };
    lfs.enable = true;
    delta.enable = true;
    aliases = {
      br = "branch";
      c = "commit -m";
      ca = "commit -am";
      co = "checkout";
      d = "diff";
      df = "!git hist | peco | awk '{print $2}' | xargs -I {} git diff {}^ {}";
      edit-unmerged = "!f() { git ls-files --unmerged | cut -f2 | sort -u ; }; vim `f`";
      fuck = "commit --amend -m";
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
}
