{
  programs.nvf.settings.vim = {
    terminal = {
      toggleterm = {
        enable = true;
        mappings.open = "<C-t>";

        setupOpts = {
          direction = "tab";
          lazygit = {
            enable = true;
            direction = "tab";
          };
        };
      };
    };
  };
}
