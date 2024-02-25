{
  programs.neovim-flake.settings.vim = {
    visuals = {
      enable = true;
      nvimWebDevicons.enable = true;
      scrollBar.enable = true;
      smoothScroll.enable = false;
      cellularAutomaton.enable = false;
      fidget-nvim.enable = true;
      highlight-undo.enable = true;

      indentBlankline = {
        enable = true;
        fillChar = null;
        eolChar = null;
        scope.enabled = true;
      };

      cursorline = {
        enable = true;
        lineTimeout = 0;
      };
    };
  };
}
