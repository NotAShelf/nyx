{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.programs.cnvim;
in {
  options.modules.programs.cnvim = {enable = mkEnableOption "cnvim";};

  config = mkIf cfg.enable {
    xdg.configFile."nvim".source = ./nvim;
    programs.neovim = {
      enable = true;
      package = pkgs.neovim-unwrapped;
      vimAlias = true;
      viAlias = true;
      vimdiffAlias = true;
      withRuby = false;
      withNodeJs = false;
      withPython3 = false;
      extraPackages = with pkgs; [
        texlab # latex LSP
        nil # nix language server
        sumneko-lua-language-server # lua lsp
        stylua # lua linter
        uncrustify # C and stuff
        shellcheck # shell
        alejandra # nix formatter
        gopls # go
        revive # go formatter
        asmfmt # go formatter 2
        ccls # cpp
        black # python
        shellcheck # bash
        shfmt # shell
        nodejs # take a guess
        marksman # markdown language server
        nodePackages.pyright
        nodePackages.prettier
        nodePackages.stylelint
        nodePackages.jsonlint # JSON
        nodePackages.typescript-language-server # Typescript
        nodePackages.vscode-langservers-extracted # HTML, CSS, JavaScript
        nodePackages.yarn
        nodePackages.bash-language-server
        nodePackages.node2nix # node and tix, we game
      ];
      plugins = with pkgs.vimPlugins; [
        copilot-lua
        lsp_lines-nvim
        vim-nix
        nvim-ts-autotag
        cmp-nvim-lsp-signature-help
        cmp-buffer
        comment-nvim
        lsp_lines-nvim
        null-ls-nvim
        vim-fugitive
        friendly-snippets
        luasnip
        rust-tools-nvim
        crates-nvim
        vim-illuminate
        cmp_luasnip
        nvim-cmp
        impatient-nvim
        indent-blankline-nvim
        nvim-tree-lua
        telescope-nvim
        nvim-web-devicons
        cmp-nvim-lsp
        cmp-path
        catppuccin-nvim
        lspkind-nvim
        nvim-lspconfig
        hop-nvim
        alpha-nvim
        nvim-autopairs
        nvim-colorizer-lua
        nvim-ts-rainbow
        gitsigns-nvim
        toggleterm-nvim
        todo-comments-nvim
        (nvim-treesitter.withPlugins (plugins:
          with plugins; [
            tree-sitter-python
            tree-sitter-c
            tree-sitter-nix
            tree-sitter-cpp
            tree-sitter-rust
            tree-sitter-toml
            tree-sitter-json
            tree-sitter-lua
            tree-sitter-go
            tree-sitter-java
            tree-sitter-typescript
            tree-sitter-javascript
            tree-sitter-cmake
            tree-sitter-comment
            tree-sitter-http
            tree-sitter-regex
            tree-sitter-dart
            tree-sitter-make
            tree-sitter-html
            tree-sitter-css
            tree-sitter-latex
            tree-sitter-bibtex
            tree-sitter-php
            tree-sitter-sql
            tree-sitter-zig
            tree-sitter-dockerfile
            tree-sitter-markdown
          ]))
      ];
    };
  };
}
