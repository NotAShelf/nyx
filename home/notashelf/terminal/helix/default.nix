{
  config,
  pkgs,
  inputs,
  ...
} @ args: {
  programs.helix = {
    enable = true;
    package = inputs.helix.packages."x86_64-linux".default;
    settings = {
      theme = "catppuccin_mocha_transparent";
      keys.normal = {
        "{" = "goto_prev_paragraph";
        "}" = "goto_next_paragraph";
        "X" = "extend_line_above";
        "esc" = ["collapse_selection" "keep_primary_selection"];
        space.space = "file_picker";
        space.w = ":w";
        space.q = ":bc";
        "C-d" = ["half_page_down" "align_view_center"];
        "C-u" = ["half_page_up" "align_view_center"];
        "C-q" = ":xa";
        space.u = {
          f = ":format"; # format using LSP formatter
          w = ":set whitespace.render all";
          W = ":set whitespace.render none";
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
        bufferline = "always";
        true-color = true;
        rulers = [80];
        indent-guides = {
          render = true;
        };
        rainbow-brackets = true;
        gutters = ["diagnostics" "line-numbers" "spacer" "diff"];
        statusline = {
          mode-separator = "";
          separator = "";
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
        "ui.background" = "{}";
      };
    };

    languages = import ./languages.nix args;
  };

  home.packages = with pkgs; [
    # some other lsp related packages / dev tools
    lldb
    gopls
    revive
    rust-analyzer
    texlab
    zls
    elixir_ls
    gcc
    uncrustify
    black
    alejandra
    shellcheck
    solc
    gawk
    haskellPackages.haskell-language-server
    #nodePackages.typescript-language-server
    java-language-server
    kotlin-language-server
    nodePackages.vls
    nodePackages.yaml-language-server
    nodePackages.jsonlint
    nodePackages.yarn
    sumneko-lua-language-server
    nodePackages.vscode-langservers-extracted
    cargo
  ];
}
