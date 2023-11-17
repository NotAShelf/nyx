{
  lib,
  pkgs,
  osConfig,
  inputs',
  ...
}: let
  inherit (lib) mkIf;

  dev = osConfig.modules.device;
  acceptedTypes = ["desktop" "laptop" "hybrid" "server" "lite"];
in {
  config = mkIf (builtins.elem dev.type acceptedTypes) {
    programs.helix = {
      enable = false;
      package = inputs'.helix.packages.default.overrideAttrs (self: {
        makeWrapperArgs = with pkgs;
          self.makeWrapperArgs
          or []
          ++ [
            "--suffix"
            "PATH"
            ":"
            (lib.makeBinPath [
              clang-tools
              marksman
              nil
              luajitPackages.lua-lsp
              nodePackages.bash-language-server
              nodePackages.vscode-css-languageserver-bin
              nodePackages.vscode-langservers-extracted
              nodePackages.prettier
              rustfmt
              rust-analyzer
              black
              alejandra
              shellcheck
            ])
          ];
      });
      settings = {
        theme = "catppuccin_mocha_transparent";
        icons = "nerdfonts";
        keys.normal = {
          "{" = "goto_prev_paragraph";
          "}" = "goto_next_paragraph";
          "X" = "extend_line_above";
          "esc" = ["collapse_selection" "keep_primary_selection"];
          "C-q" = ":xa";
          "C-w" = "file_picker";
          "space" = {
            "space" = "file_picker";
            "w" = ":w";
            "q" = ":bc";
            "u" = {
              "f" = ":format"; # format using LSP formatter
              "w" = ":set whitespace.render all";
              "W" = ":set whitespace.render none";
            };
          };
        };
        keys.select = {
          "%" = "match_brackets";
        };
        editor = {
          color-modes = true;
          cursorline = true;
          mouse = true;
          idle-timeout = 1;
          line-number = "relative";
          scrolloff = 5;
          rainbow-brackets = true;
          completion-replace = true;
          cursor-word = true;
          bufferline = "always";
          true-color = true;
          rulers = [80];
          soft-wrap.enable = true;
          indent-guides = {
            render = true;
          };
          sticky-context = {
            enable = true;
            indicator = true;
          };
          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };
          gutters = ["diagnostics" "line-numbers" "spacer" "diff"];
          statusline = {
            mode-separator = "";
            separator = "";
            left = ["mode" "selections" "spinner" "file-name" "total-line-numbers"];
            center = [];
            right = ["diagnostics" "file-encoding" "file-line-ending" "file-type" "position-percentage" "position"];
            mode = {
              normal = "NORMAL";
              insert = "INSERT";
              select = "SELECT";
            };
          };

          whitespace.characters = {
            space = "·";
            nbsp = "⍽";
            tab = "→";
            newline = "⤶";
          };

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "block";
          };
        };
      };
      # override catppuccin theme and remove background to fix transparency
      themes = {
        catppuccin_mocha_transparent = {
          "inherits" = "catppuccin_mocha";
          "ui.virtual.inlay-hint" = {
            fg = "surface1";
          };
          "ui.background" = "{}";
        };
      };

      languages = {
        language = [
          {
            name = "bash";
            auto-format = true;
            formatter = {
              command = "${pkgs.shfmt}/bin/shfmt";
              args = ["-i" "2" "-"];
            };
          }
          {
            name = "html";
            file-types = ["html" "tera"];
          }
          {
            name = "clojure";
            injection-regex = "(clojure|clj|edn|boot|yuck)";
            file-types = ["clj" "cljs" "cljc" "clje" "cljr" "cljx" "edn" "boot" "yuck"];
          }
        ];

        language-server = {
          bash-language-server = {
            command = "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server";
            args = ["start"];
          };

          clangd = {
            command = "${pkgs.clang-tools}/bin/clangd";
            clangd.fallbackFlags = ["-std=c++2b"];
          };

          nil = {
            command = lib.getExe pkgs.nil;
            config.nil.formatting.command = ["${lib.getExe pkgs.alejandra}" "-q"];
          };

          vscode-css-language-server = {
            command = "${pkgs.nodePackages.vscode-css-languageserver-bin}/bin/css-languageserver";
            args = ["--stdio"];
          };
        };
      };
    };

    home.packages = with pkgs; [
      # some other lsp related packages / dev tools
      lldb # debugging stuff
      gopls # go
      revive # go
      rust-analyzer # rust
      texlab # latex
      zls # zig
      #elixir_ls # broken
      gcc # C/++
      uncrustify # source code beautifier
      black # python
      alejandra # nix formatting
      shellcheck # bash
      gawk
      haskellPackages.haskell-language-server
      nodePackages.typescript-language-server
      java-language-server
      kotlin-language-server
      nodePackages.vls
      nodePackages.yaml-language-server
      nodePackages.jsonlint
      nodePackages.yarn
      nodePackages.pnpm
      sumneko-lua-language-server
      nodePackages.vscode-langservers-extracted
      cargo
    ];
  };
}
