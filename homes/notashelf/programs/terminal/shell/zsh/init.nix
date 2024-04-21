{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) readFile;
  inherit (lib.strings) fileContents;
  inherit (osConfig.modules.style.colorScheme) colors;
in {
  programs.zsh = {
    completionInit = ''
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
      source ${pkgs.git}/share/git/contrib/completion/git-prompt.sh
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
      ${fileContents ./rc/misc.zsh}

      # Hyperoptimized time format for the time command
      # the definition of the format is as follows:
      # - "[%J]": The name of the job.
      # - "%uU user": CPU seconds spent in user mode.
      # - "%uS system": CPU seconds spent in kernel mode.
      # - "%uE/%*E elapsed": Elapsed time in seconds
      # - "%P CPU": The CPU percentage, computed as 100*(%U+%S)/%E.
      # - "(%X avgtext + %D avgdata + %M maxresident)k": The average amount in (shared) text space used in kilobytes, the
      # average amount in (unshared) data/stack space used in kilobytes, and the maximum memory
      # the process had in use at any time in kilobytes.
      # - "[%I inputs / %O outputs]": Number of input and output operations
      # - "(%Fmajor + %Rminor) pagefaults": The number of major & minor page faults.
      # - "%W swaps": The number of times the process was swapped.
      TIMEFMT=$'\033[1m[%J]\033[0m: %uU user | %uS system | %uE/%*E elapsed | %P CPU\n> (%X avgtext + %D avgdata + %M maxresident)k used\n> [%I inputs / %O outputs] | (%Fmajor + %Rminor) pagefaults | %W swaps'

      # Set LS_COLORS by parsing dircolors output
      LS_COLORS="$(${pkgs.coreutils}/bin/dircolors --sh)"
      LS_COLORS="''${''${LS_COLORS#*\'}%\'*}"
      export LS_COLORS
    '';
  };
}
