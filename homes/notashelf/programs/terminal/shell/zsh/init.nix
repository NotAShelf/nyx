{
  osConfig,
  lib,
  ...
}: let
  inherit (builtins) readFile;
  inherit (lib.strings) fileContents;
  inherit (osConfig.modules.style.colorScheme) colors;
in {
  programs.zsh = {
    completionInit = ''
        ${readFile ./rc/comp.zsh}
        ${readFile ./rc/fzf.zsh}

        # configure fzf tab options
        export FZF_DEFAULT_OPTS="
         --color gutter:-1
          --color bg:-1
          --color bg+:-1
          --color fg:#${colors.base04}
          --color fg+:#${colors.base06}
          --color hl:#${colors.base0D}
          --color hl+:#${colors.base0D}
          --color header:#${colors.base0D}
          --color info:#${colors.base0A}
          --color marker:#${colors.base0C}
          --color pointer:#${colors.base0C}
          --color prompt:#${colors.base0A}
          --color spinner:#${colors.base0C}
          --color preview-bg:#${colors.base01}
          --color preview-fg:#${colors.base0D}
          --prompt ' '
          --pointer ''
          --layout=reverse
          -m --bind ctrl-space:toggle,pgup:preview-up,pgdn:preview-down
      "
    '';

    initExtra = ''
      # avoid duplicated entries in PATH
      typeset -U PATH

      # try to correct the spelling of commands
      setopt correct
      # disable C-S/C-Q
      setopt noflowcontrol
      # disable "no matches found" check
      unsetopt nomatch

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
    '';

    initExtraFirst = ''
      # Do this early so fast-syntax-highlighting can wrap and override this
      if autoload history-search-end; then
        zle -N history-beginning-search-backward-end history-search-end
        zle -N history-beginning-search-forward-end  history-search-end
      fi
    '';
  };
}
