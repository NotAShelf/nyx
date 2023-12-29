{pkgs, ...}: {
  programs = {
    git = {
      enable = true;
      lfs.enable = true;
    };

    neovim = {
      enable = true;

      viAlias = true;
      vimAlias = true;
      defaultEditor = true;

      configure = {
        customRC = with builtins; ''
          ${readFile ./nvim/init.vim}
          ${readFile ./nvim/maps.vim}
          ${readFile ./nvim/plugins.vim}
        '';

        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [
            # general utils
            direnv-vim # direnv for vim
            dressing-nvim # better UI components

            leap-nvim # navigation
            lualine-nvim # statusline
            tabular # align text according to regexp
            undotree # undo history
            vim-css-color # highlight CSS colors
            vim-signature # marks on signcolumn
            which-key-nvim # mapping manager and cheatsheet
            vim-sneak

            # completion
            nvim-cmp
            cmp-buffer
            cmp-cmdline
            cmp-nvim-lsp
            cmp-path
            cmp_luasnip

            comment-nvim
            todo-comments-nvim

            luasnip
            friendly-snippets

            nvim-lspconfig
            nvim-lint
            fidget-nvim
            aerial-nvim

            telescope-nvim # list of files interface
            telescope-file-browser-nvim
            telescope-fzy-native-nvim

            vim-fugitive # git in vim
            gitsigns-nvim

            targets-vim # text objects
            vim-surround
            vim-expand-region

            nvim-treesitter.withAllGrammars # better highlighting
          ];
        };
      };
    };
  };
}
