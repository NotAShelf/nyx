{
  programs.nvf.settings.vim = {
    visuals = {
      enable = true;
      nvimWebDevicons.enable = true;
      scrollBar.enable = true;
      smoothScroll.enable = false;
      cellularAutomaton.enable = false;
      highlight-undo.enable = true;

      indentBlankline = {
        enable = true;
      };

      cursorline = {
        enable = true;
        lineTimeout = 0;
      };

      fidget-nvim = {
        enable = true;
        setupOpts = {
          notification.window = {
            winblend = 0;
            border = "none";
          };
        };
      };
    };
  };
}
