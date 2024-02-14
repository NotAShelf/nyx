{
  programs.bash = {
    enable = false;
    enableCompletion = true;
    bashrcExtra = ''
      set -o vi
      bind -m vi-command 'Control-l: clear-screen'
      bind -m vi-insert 'Control-l: clear-screen'

      bind 'set show-mode-in-prompt on'
      bind 'set vi-cmd-mode-string "n "'
      bind 'set vi-ins-mode-string "i "'

      # use ctrl-z to toggle in and out of bg
      if [[ $- == *i* ]]; then
        stty susp undef
        bind -m vi-command 'Control-z: fg\015'
        bind -m vi-insert 'Control-z: fg\015'
      fi
    '';
  };
}
