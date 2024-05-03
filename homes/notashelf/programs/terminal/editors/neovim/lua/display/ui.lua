local opt = vim.opt

opt.cmdheight = 0
opt.colorcolumn = '+0' -- Align text at 'textwidth'
opt.showtabline = 2 -- Always show the tabs line
opt.helpheight = 0 -- Disable help window resizing
opt.winwidth = 30 -- Minimum width for active window
opt.winminwidth = 1 -- Minimum width for inactive windows
opt.winheight = 1 -- Minimum height for active window
opt.winminheight = 1 -- Minimum height for inactive window
opt.pumheight = 10 -- Maximum number of items to show in the popup menu
-- opt.pumblend = 100  -- Popup blend, 100 means transparent

opt.cursorline = true
opt.whichwrap:append('<,>,h,l,[,]')

-- haracters to fill the statuslines, vertical separators and special
-- lines in the window.opt.whichwrap:append('<,>,h,l,[,]')
opt.fillchars = {
  -- replace window borderss with slightly thicker characters
  -- although taking a bit of more space, it helps me better
  -- identify the window borders
  horiz = '━',
  horizup = '┻',
  horizdown = '┳',
  vert = '┃',
  vertleft = '┫',
  vertright = '┣',
  verthoriz = '╋',

  eob = ' ', -- end of buffer
  diff = '╱', -- deleted lines of the 'diff' option

  -- replace fold chars
  fold = ' ',
  foldclose = '',
  foldopen = '',
}

opt.list = true
opt.listchars = {
  tab = '→ ',
  -- eol = '⤶ ',
  -- eol = '⤶ ',
  -- bsp = '␣',
  -- trail = '·',
  -- space = '·',
  extends = '»',
  precedes = '«',
}
