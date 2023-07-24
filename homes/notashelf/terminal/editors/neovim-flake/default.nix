{
  inputs,
  pkgs,
  ...
}: let
  neovim = inputs.neovim-flake;
in {
  imports = [
    neovim.homeManagerModules.default
  ];

  programs.neovim-flake = {
    enable = true;
    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;
        enableEditorconfig = true;
        preventJunkFiles = true;
        enableLuaLoader = true;

        startPlugins = with pkgs; [vimPlugins.nvim-surround];
        luaConfigRC.test = neovim.lib.nvim.dag.entryAnywhere ''
          require("nvim-surround").setup({})
        '';

        debugMode = {
          enable = false;
          level = 20;
          logFile = "/tmp/nvim.log";
        };
      };

      vim.lsp = {
        formatOnSave = true;
        lspkind.enable = false;
        lightbulb.enable = true;
        lspsaga.enable = false;
        nvimCodeActionMenu.enable = true;
        trouble.enable = true;
        lspSignature.enable = true;
      };

      vim.debugger.nvim-dap = {
        ui.enable = true;
      };

      vim.languages = {
        enableLSP = true;
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        nix.enable = true;
        html.enable = true;
        clang = {
          enable = true;
          lsp = {
            enable = true;
            server = "clangd";
          };
        };
        sql.enable = false;
        ts.enable = true;
        go.enable = true;
        zig.enable = false;
        python.enable = false;
        dart.enable = false;
        elixir.enable = false;
        svelte.enable = false;
        rust = {
          enable = true;
          crates.enable = true;
        };
      };

      vim.visuals = {
        enable = true;
        nvimWebDevicons.enable = true;
        scrollBar.enable = true;
        smoothScroll.enable = true;
        cellularAutomaton.enable = true;
        fidget-nvim.enable = true;
        indentBlankline = {
          enable = true;
          fillChar = null;
          eolChar = null;
          showCurrContext = true;
        };
        cursorWordline = {
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
        nvimTreeLua = {
          enable = true;
          openOnSetup = false;
          openTreeOnNewTab = false;
          indentMarkers = true;

          renderer = {
            rootFolderLabel = null;
            icons.show.git = true;
          };

          view = {
            width = 25;
            adaptiveSize = false;
          };

          mappings = {
            toggle = "<C-W>";
          };
        };
      };

      vim.tabline = {
        nvimBufferline.enable = true;
      };

      vim.treesitter.context.enable = true;

      vim.binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };

      vim.telescope.enable = true;

      vim.git = {
        enable = true;
        gitsigns.enable = true;
        gitsigns.codeActions = false;
      };

      vim.minimap = {
        # cool for vanity but practically useless
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
            "flake.nix"
            "index.*"
            ".anchor"
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
      };

      vim.terminal = {
        toggleterm = {
          mappings.open = "<C-t>";
          enable = true;
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
      };

      vim.assistant = {
        copilot = {
          enable = true;
          cmp.enable = true;
        };
      };

      vim.session = {
        nvim-session-manager = {
          enable = true;
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
