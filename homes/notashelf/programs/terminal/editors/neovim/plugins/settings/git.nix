{
  programs.neovim-flake.settings.vim = {
    git = {
      enable = true;
      vim-fugitive.enable = true;
      gitsigns = {
        enable = true;
        codeActions.enable = false; # no.
      };
    };
  };
}
