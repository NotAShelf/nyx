{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    historyLimit = 10000;
    terminal = "tmux-256color";
    extraConfig = ''
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a last-window
      set-option -g set-titles on
      set-option -g set-titles-string '#H:#S.#I.#P #W #T'
      setw -g monitor-activity on
      set-option -g status-justify left
      set-option -g status-bg yellow
      set-option -g status-fg black
    '';
  };
}
