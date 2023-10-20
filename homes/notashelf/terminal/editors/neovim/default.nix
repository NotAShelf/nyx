{
  inputs,
  pkgs,
  lib,
  ...
}: let
  neovim = inputs.neovim-flake;
  # neovim-package = inputs'.neovim-nightly.packages.default;

  htms = pkgs.fetchFromGitHub {
    owner = "calops";
    repo = "hmts.nvim";
    rev = "v0.1.0";
    hash = "sha256-SBNTtuzwSmGgwALD/JqLwXGLow+Prn7dJrQNODPeOAY=";
  };

  regexplainer = pkgs.fetchFromGitHub {
    owner = "bennypowers";
    repo = "nvim-regexplainer";
    rev = "4250c8f3c1307876384e70eeedde5149249e154f";
    hash = "sha256-15DLbKtOgUPq4DcF71jFYu31faDn52k3P1x47GL3+b0=";
  };
  /*
  highlight-undo = pkgs.fetchFromGitHub {
    owner = "tzachar";
    repo = "highlight-undo.nvim";
    rev = "50a6884a8476be04ecce8f1c4ed692c5000ef0a1";
    hash = "sha256:1krkrbj2ahdqcqvngjx05fm4vxvm5f8pia65bs6xww3aas3ivvxy";
  };
  */
in {
  imports = [neovim.homeManagerModules.default];

  programs.neovim-flake = {
    enable = true;
    settings = {
      vim = {
        package = pkgs.neovim-unwrapped;
        viAlias = true;
        vimAlias = true;

        enableEditorconfig = true;
        preventJunkFiles = true;
        enableLuaLoader = true;
        useSystemClipboard = true;

        treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          regex # for regexplainer
          markdown
          markdown-inline
        ];

        extraPlugins = let
          inherit (pkgs.vimPlugins) friendly-snippets aerial-nvim nvim-surround undotree;
        in {
          friendly-snippets = {package = friendly-snippets;};

          /*
          highlight-undo = {
            package = highlight-undo;
            setup = "require('highlight-undo').setup {}";
          };
          */

          aerial = {
            package = aerial-nvim;
            setup = "require('aerial').setup {}";
          };

          /*
          harpoon = {
            package = harpoon;
            setup = "require('harpoon').setup {}";
            after = ["aerial"];
          };
          */

          nvim-surround = {
            package = nvim-surround;
            setup = "require('nvim-surround').setup{}";
          };

          htms = {
            package = htms;
            after = ["treesitter"];
          };

          regexplainer = {
            package = regexplainer;
          };

          undotree = {
            package = undotree;
            setup = ''
              vim.g.undotree_ShortIndicators = true
              vim.g.undotree_TreeVertShape = '│'
            '';
          };
        };

        debugMode = {
          enable = false;
          logFile = "/tmp/nvim.log";
        };
      };

      vim.lsp = {
        formatOnSave = true;
        lspkind.enable = true;
        lsplines.enable = true;
        lightbulb.enable = true;
        lspsaga.enable = false;
        lspSignature.enable = true;
        nvimCodeActionMenu.enable = true;
        trouble.enable = false;
      };

      vim.debugger.nvim-dap = {
        enable = true;
        ui.enable = true;
      };

      vim.languages = {
        enableLSP = true;
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        nix.enable = true;
        html.enable = true;
        ts.enable = true;
        go.enable = true;
        python.enable = true;
        bash.enable = true;
        zig.enable = false;
        dart.enable = false;
        elixir.enable = false;
        svelte.enable = false;
        sql.enable = false;

        lua = {
          enable = true;
          lsp.neodev.enable = true;
        };

        rust = {
          enable = true;
          crates.enable = true;
        };

        clang = {
          enable = true;
          lsp = {
            enable = true;
            server = "clangd";
          };
        };
      };

      vim.visuals = {
        enable = true;
        nvimWebDevicons.enable = true;
        scrollBar.enable = true;
        smoothScroll.enable = false;
        cellularAutomaton.enable = false;
        fidget-nvim.enable = true;

        indentBlankline = {
          enable = true;
          fillChar = null;
          eolChar = null;
          showCurrContext = true;
        };

        cursorline = {
          enable = true;
          lineTimeout = 0;
        };
      };

      vim.statusline = {
        lualine = {
          enable = true;
          theme = "catppuccin";
        };
      };

      vim.theme = {
        enable = true;
        name = "catppuccin";
        style = "mocha";
        transparent = true;
      };
      vim.autopairs.enable = true;

      vim.autocomplete = {
        enable = true;
        type = "nvim-cmp";
      };

      vim.filetree = {
        nvimTree = {
          enable = true;
          openOnSetup = true;
          disableNetrw = true;

          hijackUnnamedBufferWhenOpening = true;
          hijackCursor = true;
          hijackDirectories = {
            enable = true;
            autoOpen = true;
          };

          git = {
            enable = true;
            showOnDirs = false;
            timeout = 100;
          };

          view = {
            preserveWindowProportions = false;
            cursorline = false;
            width = 35;
          };

          renderer = {
            indentMarkers.enable = true;
            rootFolderLabel = false;

            icons = {
              modifiedPlacement = "after";
              gitPlacement = "after";
              show.git = true;
              show.modified = true;
            };
          };

          diagnostics.enable = true;

          modified = {
            enable = true;
            showOnDirs = false;
            showOnOpenDirs = true;
          };

          mappings = {
            toggle = "<C-w>";
          };
        };
      };

      vim.tabline = {
        nvimBufferline.enable = true;
      };

      vim.treesitter = {
        fold = true;
        context.enable = true;
      };

      vim.binds = {
        whichKey.enable = true;
        cheatsheet.enable = false;
      };

      vim.telescope.enable = true;

      vim.git = {
        enable = true;
        gitsigns.enable = true;
        gitsigns.codeActions = false;
      };

      vim.minimap = {
        # cool for vanity but practically useless on small screens
        minimap-vim.enable = false;
        codewindow.enable = false;
      };

      vim.dashboard = {
        dashboard-nvim.enable = false;
        alpha.enable = true;
      };

      vim.notify = {
        nvim-notify.enable = true;
      };

      vim.projects = {
        project-nvim = {
          enable = true;
          manualMode = false;
          detectionMethods = ["lsp" "pattern"];
          patterns = [
            ".git"
            ".hg"
            "Makefile"
            "package.json"
            "index.*"
            ".anchor"
            "flake.nix"
            "index.*"
          ];
        };
      };

      vim.utility = {
        ccc.enable = true;
        icon-picker.enable = true;
        diffview-nvim.enable = true;
        vim-wakatime = {
          enable = true;
          cli-package = pkgs.wakatime;
        };
        motion = {
          hop.enable = true;
          leap.enable = false;
        };
      };

      vim.notes = {
        mind-nvim.enable = true;
        todo-comments.enable = true;
        obsidian.enable = false;
      };

      vim.terminal = {
        toggleterm = {
          enable = true;
          mappings.open = "<C-t>";
          direction = "tab";
          lazygit = {
            enable = true;
            direction = "tab";
          };
        };
      };

      vim.ui = {
        noice.enable = true;
        colorizer.enable = true;
        modes-nvim.enable = false;
        illuminate.enable = true;

        breadcrumbs = {
          enable = true;
          source = "nvim-navic";
          navbuddy.enable = false;
        };

        smartcolumn = {
          enable = true;
          columnAt.languages = {
            markdown = 80;
            nix = 150;
            ruby = 110;
            java = 120;
            go = [130];
          };
        };

        borders = {
          enable = true;
          globalStyle = "rounded";
        };
      };

      vim.assistant = {
        copilot = {
          enable = true;
          cmp.enable = true;
        };
      };

      vim.session = {
        nvim-session-manager = {
          enable = false;
          autoloadMode = "Disabled"; # misbehaves with dashboard
        };
      };

      vim.gestures = {
        gesture-nvim.enable = false;
      };

      vim.comments = {
        comment-nvim.enable = true;
      };

      vim.presence = {
        presence-nvim.enable = true;
      };
    };
  };
}
