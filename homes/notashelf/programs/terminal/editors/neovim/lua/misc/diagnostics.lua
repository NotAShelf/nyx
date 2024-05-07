-- Diagnostic settings:
-- see: `:help vim.diagnostic.config`
vim.diagnostic.config({
  update_in_insert = true,
  virtual_text = false,
  signs = true,
  underline = true,
  severity_sort = true,
  virtual_lines = {
    only_current_line = true,
    spacing = 2,
  },

  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})
