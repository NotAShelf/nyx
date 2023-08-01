{
  inputs,
  pkgs,
  ...
}: let
  neovim = inputs.neovim-flake;

  beacon = pkgs.fetchFromGitHub {
    owner = "DanilaMihailov";
    repo = "beacon.nvim";
    rev = "a786c9a89b2c739c69f9500a2f70f2586c06ec27";
    hash = "sha256-qD0dwccNjhJ7xyM+yG8bSFUyPn7hHZyC0RBy3MW1hz0=";
  };
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

        extraPlugins = with pkgs.vimPlugins; {
          aerial = {
            package = aerial-nvim;
            setup = "require('aerial').setup {}";
          };

          harpoon = {
            package = harpoon;
            setup = "require('harpoon').setup {}";
            after = ["aerial"];
          };

          nvim-surround = {
            package = nvim-surround;
            setup = "require('nvim-surround').setup{}";
          };

          beacon-nvim = {
            package = beacon;
            setup = ''
              vim.cmd([[
                let g:beacon_timeout = 450
                let g:beacon_size = 70
                let g:beacon_minimal_jump = 10
                let g:beacon_ignore_filetypes = ["toggleterm", "NvimTree", "qf", "help", "TelescopePrompt", "harpoon", "grapple", "fzf", "portal", "nvim-navbuddy"]
                " highlight Beacon guibg=#3a567d
                " base = "#3a567d", " bright = "#617897", " dim = "#2e4564"
              ]])
            '';
          };
        };

        debugMode = {
          enable = false;
          level = 20;
          logFile = "/tmp/nvim.log";
        };
      };

      vim.lsp = {
        formatOnSave = true;
        lspkind.enable = true;
        lsplines.enable = true;
        lightbulb.enable = true;
        lspsaga.enable = false;
        nvimCodeActionMenu.enable = true;
        trouble.enable = false;
        lspSignature.enable = true;
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
        sql.enable = false;
        ts.enable = true;
        go.enable = true;
        python.enable = true;
        zig.enable = false;
        dart.enable = false;
        elixir.enable = false;
        svelte.enable = false;

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
        nvimTree = {
          enable = true;
          openOnSetup = true;
          disableNetrw = true;

          hijackUnnamedBufferWhenOpening = false;
          hijackCursor = true;
          hijackDirectories = {
            enable = true;
            autoOpen = false;
          };

          git = {
            enable = true;
            showOnDirs = false;
            timeout = 100;
          };

          view = {
            cursorline = false;
            width = {
              min = 35;
              max = -1;
              padding = 1;
            };
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

      vim.treesitter.context.enable = true;

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
        alpha.enable = false;
      };

      vim.notify = {
        nvim-notify.enable = true;
      };

      vim.projects = {
        project-nvim = {
          enable = false;
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
