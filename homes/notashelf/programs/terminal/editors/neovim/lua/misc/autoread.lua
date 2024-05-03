-- If the cursor has been idle for some time, check if the current buffer
-- has been modified externally. prompt the user to reload it if has.
local bufnr = vim.api.nvim_get_current_buf()

-- luacheck: ignore
vim.opt_local.autoread = true
vim.api.nvim_create_autocmd('CursorHold', {
  group = vim.api.nvim_create_augroup('Autoread', { clear = true }),
  buffer = bufnr,
  callback = function()
    vim.cmd('silent! checktime')
  end,
})
