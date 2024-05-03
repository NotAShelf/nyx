-- Some of those are already disasbled in the Neovim wrapper
-- as configured by nvf. I'm just making sure they are disabled
-- here as well.
local disable_distribution_plugins = function()
  vim.g.loaded_gzip = 1
  vim.g.loaded_tar = 1
  vim.g.loaded_tarPlugin = 1
  vim.g.loaded_zip = 1
  vim.g.loaded_zipPlugin = 1
  vim.g.loaded_getscript = 1
  vim.g.loaded_getscriptPlugin = 1
  vim.g.loaded_vimball = 1
  vim.g.loaded_vimballPlugin = 1
  vim.g.loaded_matchit = 1
  vim.g.loaded_matchparen = 1
  vim.g.loaded_2html_plugin = 1
  vim.g.loaded_logiPat = 1
  vim.g.loaded_rrhelper = 1
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  vim.g.loaded_netrwSettings = 1
  vim.g.loaded_netrwFileHandlers = 1
  vim.g.skip_ts_context_commentstring_module = true
end

-- https://github.com/neovim/neovim/issues/14090#issuecomment-1177933661
-- vim.g.do_filetype_lua = 1
-- vim.g.did_load_filetypes = 0

-- Neovim should not be able to load from those paths since
-- we ultimately want to be able to *only* want the nvf config
-- to be the effective one
vim.opt.runtimepath:remove('/etc/xdg/nvim')
vim.opt.runtimepath:remove('/etc/xdg/nvim/after')
vim.opt.runtimepath:remove('/usr/share/vim/vimfiles')

disable_distribution_plugins()
