{pkgs, ...}: let
  inherit (builtins) readFile;
in {
  programs = {
    neovim = {
      enable = true;

      withRuby = false;
      withPython3 = false;
      withNodeJs = false;

      viAlias = true;
      vimAlias = true;

      defaultEditor = true;

      configure = {
        customRC = ''
          " -- init --
          ${readFile ./config/init.vim}

          " -- mappings --
          ${readFile ./config/maps.vim}

          " -- plugin configs --
          ${readFile ./config/plugins.vim}

          " -- lua configuration --
          lua EOF <<
          -- set statusline colors
          vim.cmd([[
            hi VertSplit guifg=#151515
            hi User1 guifg=#999999 guibg=#151515
            hi User2 guifg=#eea040 guibg=#151515
            hi User3 guifg=#0072ff guibg=#151515
            hi User4 guifg=#ffffff guibg=#151515
            hi User5 guifg=#777777 guibg=#151515
          ]])

          -- set statusline
          vim.o.statusline = table.concat({
            "%1* %n %*",       -- buffer number
            "%3* %y %*",       -- file type
            -- "%4* %<%F %*",  -- full path
            "%4* %<%f %*",     -- file name
            "%2* %m %*",       -- modified flag
            "%1* %= %5l %*",   -- current line
            "%2* / %L %*",       -- total lines
            "%1* %4v %*",      -- virtual column number
            "%2* 0x%04B %*",   -- character under cursor
            "%5* %{&ff} %*",   -- file format
          })
        '';

        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [
            # general utils
            direnv-vim # direnv for vim
            dressing-nvim # better UI components

            leap-nvim # navigation
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
