-- alias for vim.api.nvim_create_autocmd
local create_autocmd = vim.api.nvim_create_autocmd
-- alias for vim.api.nvim_create_augroup
local create_augroup = vim.api.nvim_create_augroup

-- taken from https://github.com/sitiom/nvim-numbertoggle
-- I would much rather avoid fetching yet another plugin for something
-- that should be done locally - and not as a plugin
local augroup = create_augroup('NumberToggle', {})

create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'CmdlineLeave', 'WinEnter' }, {
  pattern = '*',
  group = augroup,
  callback = function()
    if vim.o.nu and vim.api.nvim_get_mode().mode ~= 'i' then
      vim.opt.relativenumber = true
    end
  end,
})

create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'CmdlineEnter', 'WinLeave' }, {
  pattern = '*',
  group = augroup,
  callback = function()
    if vim.o.nu then
      vim.opt.relativenumber = false
      vim.cmd('redraw')
    end
  end,
})
