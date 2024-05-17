{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.strings) fileContents;
in {
  programs.zsh = {
    completionInit = ''
      # Load compinit
      autoload -U compinit
      zmodload zsh/complist

      _comp_options+=(globdots)
      zcompdump="$XDG_DATA_HOME"/zsh/.zcompdump-"$ZSH_VERSION"-"$(date --iso-8601=date)"
      compinit -d "$zcompdump"

      # Recompile zcompdump if it exists and is newer than zcompdump.zwc
      # compdumps are marked with the current date in yyyy-mm-dd format
      # which means this is likely to recompile daily
      # also see: <https://htr3n.github.io/2018/07/faster-zsh/>
      if [[ -s "$zcompdump" && (! -s "$zcompdump".zwc || "$zcompdump" -nt "$zcompdump".zwc) ]]; then
        zcompile "$zcompdump"
      fi

      # Load bash completion functions.
      autoload -U +X bashcompinit && bashcompinit

      ${fileContents ./rc/comp.zsh}
    '';

    initExtraFirst = ''
      # avoid duplicated entries in PATH
      typeset -U PATH

      # try to correct the spelling of commands
      setopt correct
      # disable C-S/C-Q
      setopt noflowcontrol
      # disable "no matches found" check
      unsetopt nomatch

      # autosuggests otherwise breaks these widgets.
      # <https://github.com/zsh-users/zsh-autosuggestions/issues/619>
      ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(history-beginning-search-backward-end history-beginning-search-forward-end)

      # Do this early so fast-syntax-highlighting can wrap and override this
      if autoload history-search-end; then
        zle -N history-beginning-search-backward-end history-search-end
        zle -N history-beginning-search-forward-end  history-search-end
      fi

      source <(${lib.getExe pkgs.fzf} --zsh)
      source ${config.programs.git.package}/share/git/contrib/completion/git-prompt.sh
    '';

    initExtra = ''
      # my helper functions for setting zsh options that I normally use on my shell
      # a description of each option can be found in the Zsh manual
      # <https://zsh.sourceforge.io/Doc/Release/Options.html>
      # NOTE: this slows down shell startup time considerably
      ${fileContents ./rc/unset.zsh}
      ${fileContents ./rc/set.zsh}

      # binds, zsh modules and everything else
      ${fileContents ./rc/binds.zsh}
      ${fileContents ./rc/modules.zsh}
      ${fileContents ./rc/fzf-tab.zsh}
      ${fileContents ./rc/misc.zsh}

      # Set LS_COLORS by parsing dircolors output
      LS_COLORS="$(${pkgs.coreutils}/bin/dircolors --sh)"
      LS_COLORS="''${''${LS_COLORS#*\'}%\'*}"
      export LS_COLORS
    '';
  };
}
