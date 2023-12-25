{
  inputs',
  inputs,
  config,
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

  specs-nvim = pkgs.fetchFromGitHub {
    owner = "edluffy";
    repo = "specs.nvim";
    rev = "2743e412bbe21c9d73954c403d01e8de7377890d";
    hash = "sha256-mYTzltCEKO8C7BJ3WrB/iFa1Qq1rgJlcjW6NYHPfmPk=";
  };
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

        extraPlugins = let
          inherit (pkgs.vimPlugins) friendly-snippets aerial-nvim nvim-surround undotree mkdir-nvim ssr-nvim direnv-vim;
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
        };

        debugMode = {
          enable = false;
          logFile = "/tmp/nvim.log";
        };
      };

      vim = {
        lsp = {
          formatOnSave = true;
          lspkind.enable = true;
          lsplines.enable = true;
          lightbulb.enable = true;
          lspsaga.enable = false;
          lspSignature.enable = true;
          nvimCodeActionMenu.enable = true;
          trouble.enable = false;
          nvim-docs-view.enable = true;
        };

        debugger.nvim-dap = {
          enable = true;
          ui.enable = true;
        };

        languages = {
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
          java = {
            enable = true;
            lsp.package = ["${lib.getExe pkgs.jdt-language-server}" "-configuration" "${config.xdg.cacheHome}/jdtls/config" "-data" "${config.xdg.cacheHome}/jdtls/workspace"];
          };

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

        visuals = {
          enable = true;
          nvimWebDevicons.enable = true;
          scrollBar.enable = true;
          smoothScroll.enable = false;
          cellularAutomaton.enable = false;
          fidget-nvim.enable = true;
          highlight-undo.enable = true;

          indentBlankline = {
            enable = true;
            fillChar = null;
            eolChar = null;
            scope.enabled = true;
          };

          cursorline = {
            enable = true;
            lineTimeout = 0;
          };
        };

        statusline = {
          lualine = {
            enable = true;
            theme = "catppuccin";
            extraActiveSection.z = [
              ''
                {
                  -- display a word counter for the current buffer
                  function() return vim.api.nvim_buf_line_count(0) end,
                },
              ''
            ];
          };
        };

        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
          transparent = true;
        };
        autopairs.enable = true;

        autocomplete = {
          enable = true;
          type = "nvim-cmp";
          mappings = {
            # close = "<C-e>";
            confirm = "<C-y>";
            next = "<C-n>";
            previous = "<C-p>";
            scrollDocsDown = "<C-j>";
            scrollDocsUp = "<C-k>";
          };
        };

        filetree = {
          nvimTree = {
            enable = true;
            openOnSetup = true;
            disableNetrw = true;
            updateFocusedFile.enable = true;

            hijackUnnamedBufferWhenOpening = true;
            hijackCursor = true;

            /*
            hijackDirectories = {
              enable = true;
              autoOpen = true;
            };
            */

            git = {
              enable = true;
              showOnDirs = false;
              timeout = 500;
            };

            view = {
              cursorline = false;
              width = 35;
            };

            renderer = {
              indentMarkers.enable = true;
              rootFolderLabel = false; # inconsistent

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

            actions = {
              changeDir.enable = false;
              changeDir.global = false;
              openFile.windowPicker.enable = true;
            };

            mappings = {
              toggle = "<C-w>";
            };
          };
        };

        tabline = {
          nvimBufferline.enable = true;
        };

        treesitter = {
          fold = true;
          context.enable = true;
          grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            regex # for regexplainer
            markdown
            markdown-inline
          ];
        };

        binds = {
          whichKey.enable = true;
          cheatsheet.enable = false;
        };

        telescope.enable = true;

        git = {
          enable = true;
          gitsigns.enable = true;
          gitsigns.codeActions = false;
        };

        minimap = {
          # cool for vanity but practically useless on small screens
          minimap-vim.enable = false;
          codewindow.enable = false;
        };

        dashboard = {
          dashboard-nvim.enable = false;
          alpha.enable = true;
        };

        notify = {
          nvim-notify.enable = true;
        };

        projects = {
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
            ];
          };
        };

        utility = {
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

        notes = {
          mind-nvim.enable = true;
          todo-comments.enable = true;
          obsidian.enable = false;
        };

        terminal = {
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

        ui = {
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

        assistant.copilot = {
          enable = true;
          cmp.enable = true;
        };

        session.nvim-session-manager = {
          enable = false;
          autoloadMode = "Disabled"; # misbehaves with dashboard
        };

        gestures.gesture-nvim.enable = false;

        comments.comment-nvim.enable = true;

        presence.presence-nvim.enable = true;

        maps = import ./mappings.nix;
      };
    };
  };

  xdg.desktopEntries.neovim = lib.mkForce {
    name = "Neovim";
    type = "Application";
    mimeType = ["text/plain"];

    icon = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/NotAShelf/neovim-flake/main/assets/neovim-flake-logo-work.svg";
      sha256 = "19n7n9xafyak35pkn4cww0s5db2cr97yz78w5ppbcp9jvxw6yyz3";
    };

    exec = "${pkgs.writeShellScript "foot-neovim" ''
      filename="$(readlink -f "$1")"
      dirname="$(dirname "$filename")"

      ${lib.getExe inputs'.nyxpkgs.packages.foot-transparent} -D "$dirname" ${lib.getExe pkgs.zsh} -c "${lib.getExe pkgs.direnv} exec . nvim '$filename'"
    ''} %f";
  };
}
