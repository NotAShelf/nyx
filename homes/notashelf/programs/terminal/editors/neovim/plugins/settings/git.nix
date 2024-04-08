{
  programs.neovim-flake.settings.vim = {
    git = {
      enable = true;
      gitsigns = {
        enable = true;
        codeActions = false;
      };
    };
  };
}
