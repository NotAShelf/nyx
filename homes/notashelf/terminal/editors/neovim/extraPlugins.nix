{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs.vimPlugins) friendly-snippets aerial-nvim nvim-surround undotree mkdir-nvim ssr-nvim direnv-vim;
  inherit (pkgs.vimUtils) buildVimPlugin;

  htms = buildVimPlugin {
    name = "htms.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "calops";
      repo = "hmts.nvim";
      rev = "v0.1.0";
      hash = "sha256-SBNTtuzwSmGgwALD/JqLwXGLow+Prn7dJrQNODPeOAY=";
    };
  };

  regexplainer = buildVimPlugin {
    name = "nvim-regexplainer";
    src = pkgs.fetchFromGitHub {
      owner = "bennypowers";
      repo = "nvim-regexplainer";
      rev = "4250c8f3c1307876384e70eeedde5149249e154f";
      hash = "sha256-15DLbKtOgUPq4DcF71jFYu31faDn52k3P1x47GL3+b0=";
    };
  };

  specs-nvim = buildVimPlugin {
    name = "specs.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "edluffy";
      repo = "specs.nvim";
      rev = "2743e412bbe21c9d73954c403d01e8de7377890d";
      hash = "sha256-mYTzltCEKO8C7BJ3WrB/iFa1Qq1rgJlcjW6NYHPfmPk=";
    };
  };

  deferred-clipboard = buildVimPlugin {
    name = "deferred-clipboard";
    src = pkgs.fetchFromGitHub {
      owner = "EtiamNullam";
      repo = "deferred-clipboard.nvim";
      rev = "810a29d166eaa41afc220cc7cd85eeaa3c43b37f";
      hash = "sha256-nanNQEtpjv0YKEkkrPmq/5FPxq+Yj/19cs0Gf7YgKjU=";
    };
  };
in {
  friendly-snippets = {package = friendly-snippets;};
  mkdir-nvim = {package = mkdir-nvim;};
  regexplainer = {package = regexplainer;};
  specs-nvim = {
    package = specs-nvim;
    setup = ''
      require('specs').setup {
        show_jumps = true,
        popup = {
          delay_ms = 0,
          inc_ms = 15,
          blend = 15,
          width = 10,
          winhl = "PMenu",
          fader = require('specs').linear_fader,
          resizer = require('specs').shrink_resizer
        },

        ignore_filetypes = {'NvimTree', 'undotree'},

        ignore_buftypes = {nofile = true},
      }

      -- toggle specs using the <C-b> keybind
      vim.api.nvim_set_keymap('n', '<C-b>', ':lua require("specs").show_specs()', { noremap = true, silent = true })

      -- bind specs to navigation keys
      vim.api.nvim_set_keymap('n', 'n', 'n:lua require("specs").show_specs()<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', 'N', 'N:lua require("specs").show_specs()<CR>', { noremap = true, silent = true })
    '';
  };

  aerial = {
    package = aerial-nvim;
    setup = "require('aerial').setup {}";
  };

  nvim-surround = {
    package = nvim-surround;
    setup = "require('nvim-surround').setup {}";
  };

  htms = {
    package = htms;
    after = ["treesitter"];
  };

  undotree = {
    package = undotree;
    setup = ''
      vim.g.undotree_ShortIndicators = true
      vim.g.undotree_TreeVertShape = '│'
    '';
  };

  ssr-nvim = {
    package = ssr-nvim;
    setup = "require('ssr').setup {}";
  };

  direnv = {package = direnv-vim;};
  deferred-clipboard = {
    package = deferred-clipboard;
    setup = ''
      require('deferred-clipboard').setup {
        fallback = 'unnamedplus'
      }
    '';
  };
}
