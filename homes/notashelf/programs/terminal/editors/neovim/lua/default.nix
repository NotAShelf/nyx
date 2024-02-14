{
  # additional LSP handler configurations via vim.lsp.handlers
  "lsp-handler" = builtins.readFile ./handlers.lua;

  # additional neovide configuration
  "neovide" = builtins.readFile ./neovide.lua;
}
