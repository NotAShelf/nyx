local opt = vim.opt
local options = {
  showmode = false, -- disable the -- STATUS -- line
  showtabline = 0, -- never show the tabline
  startofline = true, -- motions like "G" also move to the first char
  virtualedit = 'block', -- visual-block mode can select beyond end of line
  showmatch = true, -- when closing a bracket, briefly flash the matching one
  matchtime = 1, -- duration of that flashing n deci-seconds
  signcolumn = 'yes:1', -- static width
  report = 9001, -- disable "x more/fewer lines" messages
  diffopt = opt.diffopt:append('vertical'), -- diff mode: vertical splits
  backspace = { 'indent', 'eol', 'start' }, -- backspace through everything in insert mode
  hidden = true, -- Enable background buffers
  history = 100, -- Remember N lines in history
  lazyredraw = false, -- Faster scrolling if enabled, breaks noice
  synmaxcol = 240, -- Max column for syntax highlight
  updatetime = 250, -- ms to wait for trigger an event

  -- If 0, move cursor line will not scroll window.
  -- If 999, cursor line will always be in middle of window.
  scrolloff = 0,
}

-- iterate over the options table and set the options
-- for each key = value pair
for key, value in pairs(options) do
  opt[key] = value
end

if not vim.g.vscode then
  opt.timeoutlen = 300 -- Time out on mappings
end

-- Don't auto-comment new lines automatically
-- that happens when you press enter at the end
-- of a comment line, and comments the next line
-- That's annoying and we don't want it!
-- don't continue comments automagically
-- https://neovim.io/doc/user/options.html#'formatoptions'
opt.formatoptions:remove('c')
opt.formatoptions:remove('r')
opt.formatoptions:remove('o')
