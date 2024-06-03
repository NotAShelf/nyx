local opt = vim.opt

-- luacheck: ignore
-- When true, all the windows are automatically made the same size after splitting or closing a window.
-- When false, splitting a window will reduce the size of the current window and leave the other windows the same.
opt.equalalways = false
opt.cmdheight = 1      -- Better display for messages
opt.colorcolumn = '+0' -- Align text at 'textwidth'
opt.showtabline = 2    -- Always show the tabs line
opt.helpheight = 0     -- Disable help window resizing
opt.winwidth = 30      -- Minimum width for active window
opt.winminwidth = 1    -- Minimum width for inactive windows
opt.winheight = 1      -- Minimum height for active window
opt.winminheight = 1   -- Minimum height for inactive window
opt.pumheight = 10     -- Maximum number of items to show in the popup menu
opt.winminwidth = 1    -- min width of inactive window
-- opt.pumblend = 100  -- Popup blend, 100 means transparent

opt.cursorline = true
opt.whichwrap:append('<,>,h,l,[,]')

opt.list = true
-- haracters to fill the statuslines, vertical separators and special
-- lines in the window.opt.whichwrap:append('<,>,h,l,[,]')
opt.fillchars:append({
  -- replace window border with slightly thicker characters
  -- although taking a bit of more space, it helps me better
  -- identify the window borders
  horiz = '━',
  horizup = '┻',
  horizdown = '┳',
  vert = '┃',
  vertleft = '┫',
  vertright = '┣',
  verthoriz = '╋',

  eob = ' ', -- suppress end of buffer lines (~)
  diff = '╱', -- deleted lines of the 'diff' option

  msgsep = '‾',

  -- replace fold chars
  fold = ' ',
  foldopen = '',
  foldclose = '',
})

-- List chars that would b shown on all modes
-- better kept simple, because it gets REALLY
-- noisy in an average buffer
local normal_listchars = {
  extends = '›', -- Alternatives: … ,»
  precedes = '‹', -- Alternatives: … ,«
}

opt.listchars = normal_listchars

-- Show listchars while in Insert mode.
local insert_listchars = {
  eol = nil,
  tab = '▎·',
  lead = '·',
  space = '·',
  trail = '.',
  multispace = '… ',
  nbsp = '¤',
}

-- Show listchars while in Insert mode.
vim.api.nvim_create_augroup('InsertModeListChars', { clear = true })
vim.api.nvim_create_autocmd({ 'InsertEnter', 'InsertLeavePre' }, {
  group = 'InsertModeListChars',
  pattern = '*',
  callback = function(args)
    if vim.tbl_contains({ 'quickfix', 'prompt' }, args.match) then
      return
    end

    if args.event == 'InsertEnter' then
      vim.opt_local.listchars = insert_listchars
    else
      vim.opt_local.listchars = normal_listchars
    end

    -- check if ibl is enabled
    -- @diagnostic disable-next-line: no-unknown, unused-local
    local status_ok, ibl = pcall(require, 'ibl')
    if not status_ok then
      return
    end
    require('ibl').debounced_refresh(0)
  end,
})
