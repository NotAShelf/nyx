-- luacheck: ignore
-- alias for vim.api.nvim_create_autocmd
local create_autocmd = vim.api.nvim_create_autocmd
-- alias for vim.api.nvim_create_augroup
local create_augroup = vim.api.nvim_create_augroup

create_autocmd('BufWritePre', {
  pattern = { '/tmp/*', 'COMMIT_EDITMSG', 'MERGE_MSG', '*.tmp', '*.bak' },
  callback = function()
    vim.opt_local.undofile = false
  end,
})

-- Remove whitespaces on save
-- this is normally handled by the formatter
-- but this should help when the formatter
-- is not working or has timed out
-- create_autocmd('BufWritePre', {
--   pattern = '',
--   command = ':%s/\\s\\+$//e',
-- })

-- Disable line wrapping & spell checking
-- for the terminal buffer
create_autocmd({ 'FileType' }, {
  pattern = { 'toggleterm' },
  callback = function()
    vim.opt_local.wrap = false
    vim.opt_local.spell = false
  end,
})

-- Enable spell checking & line wrapping
-- for git commit messages
create_autocmd({ 'FileType' }, {
  pattern = { 'gitcommit' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Highlight yank after yanking
local highlight_group = create_augroup('YankHighlight', { clear = true })
create_autocmd({ 'TextYankPost' }, {
  pattern = { '*' },
  group = highlight_group,
  callback = function()
    vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
  end,
})

-- Close terminal window if process exists with code 0
create_autocmd('TermClose', {
  callback = function()
    if not vim.b.no_auto_quit then
      vim.defer_fn(function()
        if vim.api.nvim_get_current_line() == '[Process exited 0]' then
          vim.api.nvim_buf_delete(0, { force = true })
        end
      end, 50)
    end
  end,
})

-- Start insert mode automatically
-- when editing a Git commit message
create_augroup('AutoInsert', { clear = true })
create_autocmd('FileType', {
  group = 'AutoInsert',
  pattern = 'gitcommit',
  command = 'startinsert',
})

-- Disable cursorline in insert mode
create_augroup('CursorLine', { clear = true })
create_autocmd({ 'InsertLeave', 'WinEnter' }, {
  group = 'CursorLine',
  callback = function()
    vim.wo.cursorline = true
  end,
})

create_autocmd({ 'InsertEnter', 'WinLeave' }, {
  group = 'CursorLine',
  callback = function()
    vim.wo.cursorline = false
  end,
})

-- Create the necessary directory structure for the file being saved.
create_augroup('AutoMkdir', { clear = true })
create_autocmd('BufWritePre', {
  group = 'AutoMkdir',
  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- Adjust the window size when the terminal is resized
create_autocmd('VimResized', {
  command = 'wincmd =',
})

-- Allow closing certain windows with "q"
-- and remove them from the buffer list
create_augroup('close_with_q', { clear = true })
create_autocmd('FileType', {
  group = 'close_with_q',
  pattern = {
    'help',
    'lspinfo',
    'TelescopePrompt',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

-- Mark internally when nvim is focused
-- and when it is not
create_autocmd('FocusGained', {
  callback = function()
    vim.g.nvim_focused = true
  end,
})

create_autocmd('FocusLost', {
  callback = function()
    vim.g.nvim_focused = false
  end,
})
