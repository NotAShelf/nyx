{inputs, ...}: {
  imports = [
    inputs.neovim-flake.homeManagerModules.default
  ];

  programs.neovim-flake = {
    enable = true;
    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;
        debugMode = {
          enable = false;
          level = 20;
          logFile = "/tmp/nvim.log";
        };
      };

      vim.lsp = {
        enable = true;
        formatOnSave = true;
        lightbulb.enable = true;
        lspsaga.enable = false;
        nvimCodeActionMenu.enable = true;
        trouble.enable = true;
        lspSignature.enable = true;
        rust.enable = true;
        python = true;
        clang.enable = true;
        sql = true;
        ts = true;
        go = true;
        zig.enable = true;
        nix = {
          enable = true;
          formatter = "alejandra";
        };
      };

      vim.visuals = {
        enable = true;
        nvimWebDevicons.enable = true;
        scrollBar.enable = true;
        smoothScroll.enable = true;
        cellularAutomaton.enable = true;
        fidget-nvim.enable = true;
        lspkind.enable = true;
        indentBlankline = {
          enable = true;
          fillChar = "";
          eolChar = "";
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
      };
      vim.autopairs.enable = true;

      vim.autocomplete = {
        enable = true;
        type = "nvim-cmp";
      };

      vim.filetree = {
        nvimTreeLua = {
          enable = true;
          view = {
            width = 25;
          };
        };
      };

      vim.tabline = {
        nvimBufferline.enable = true;
      };

      vim.projects = {
        project-nvim.enable = true;
      };

      vim.treesitter = {
        enable = true;
        context.enable = true;
      };

      vim.binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };

      vim.telescope = {
        enable = true;
      };

      vim.markdown = {
        enable = true;
        glow.enable = true;
      };

      vim.git = {
        enable = true;
        gitsigns.enable = true;
      };

      vim.minimap = {
        minimap-vim.enable = false;
        codewindow.enable = true; # lighter, faster, and uses lua for configuration
      };

      vim.dashboard = {
        dashboard-nvim.enable = false;
        alpha.enable = true;
      };

      vim.notify = {
        nvim-notify.enable = true;
      };

      vim.utility = {
        colorizer.enable = true;
        icon-picker.enable = true;
        venn-nvim.enable = false; # FIXME throws an error when its commands are ran manually
        diffview-nvim.enable = true;
      };

      vim.notes = {
        obsidian.enable = false; # FIXME neovim fails to build if obsidian is enabled
        orgmode.enable = false;
        mind-nvim.enable = true;
        todo-comments.enable = true;
      };

      vim.terminal = {
        toggleterm.enable = true;
      };

      vim.ui = {
        noice.enable = true;
      };

      vim.assistant = {
        copilot.enable = true;
      };

      vim.session = {
        nvim-session-manager.enable = false;
      };

      vim.gestures = {
        gesture-nvim.enable = false;
      };

      vim.comments = {
        comment-nvim.enable = true;
        kommentary. enable = false;
      };

      vim.presence = {
        presence-nvim = {
          enable = true;
          auto_update = true;
          image_text = "The one and only";
          client_id = "793271441293967371";
          main_image = "neovim";
          rich_presence = {
            editing_text = "Editing %s";
          };
        };
      };
    };
  };
}
