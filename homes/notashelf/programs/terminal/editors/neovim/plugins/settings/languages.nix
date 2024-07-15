{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.nvf.settings.vim = {
    languages = {
      enableLSP = true;
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;

      markdown.enable = true;
      nix.enable = true;
      html.enable = true;
      css.enable = true;
      tailwind.enable = true;
      ts.enable = true;
      go.enable = true;
      python.enable = true;
      bash.enable = true;
      typst.enable = true;
      zig.enable = true;
      dart.enable = false;
      elixir.enable = false;
      svelte.enable = false;
      sql.enable = false;
      java = let
        jdtlsCache = "${config.xdg.cacheHome}/jdtls";
      in {
        enable = true;
        lsp.package = [
          "${lib.getExe pkgs.jdt-language-server}"
          "-configuration ${jdtlsCache}/config"
          "-data ${jdtlsCache}/workspace"
        ];
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
  };
}
