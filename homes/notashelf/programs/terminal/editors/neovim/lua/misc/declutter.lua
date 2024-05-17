-- luacheck: ignore
vim.opt.spelllang:append('cjk') -- disable spellchecking for asian characters (VIM algorithm does not support it)

vim.opt.shortmess = {
  t = true, -- truncate file messages at start
  A = true, -- ignore annoying swap file messages
  o = true, -- file-read message overwrites previous
  O = true, -- file-read message overwrites previous
  T = true, -- truncate non-file messages in middle
  f = true, -- (file x of x) instead of just (x of x
  F = true, -- Don't give file info when editing a file, NOTE: this breaks autocommand messages
  s = true,
  c = true,
  W = true, -- Don't show [w] or written when writing
}

-- Disable nvim intro
vim.opt.shortmess:append('sI')

-- Some of those are already disasbled in the Neovim wrapper
-- as configured by nvf. I'm just making sure they are disabled
-- here as well.
local disable_distribution_plugins = function()
  local disabled_built_ins = {
    '2html_plugin',
    'getscript',
    'getscriptPlugin',
    'gzip',
    'logipat',
    'matchit',
    'matchparen',
    'tar',
    'tarPlugin',
    'rrhelper',
    'spellfile_plugin',
    'vimball',
    'vimballPlugin',
    'zip',
    'zipPlugin',
    'tutor',
    'rplugin',
    'synmenu',
    'optwin',
    'compiler',
    'bugreport',
    'ftplugin',
    'netrw',
    'netrwPlugin',
    'netrwSettings',
    'netrwFileHandlers',
    -- "skip_ts_context_commentstring_module"
  }

  for _, plugin in pairs(disabled_built_ins) do
    g['loaded_' .. plugin] = 1
  end
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
