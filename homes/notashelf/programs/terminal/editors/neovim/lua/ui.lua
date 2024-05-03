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
opt.fillchars = {
    horiz = '━',
    horizup = '┻',
    horizdown = '┳',
    vert = '┃',
    vertleft = '┫',
    vertright = '┣',
    verthoriz = '╋',
    eob = ' ',
    fold = ' ',
    diff = '╱',
}
opt.list = true
opt.listchars = {
    extends = '⟩',
    precedes = '⟨',
    trail = '·',
    tab = '╏ ',
    nbsp = '␣',
}
