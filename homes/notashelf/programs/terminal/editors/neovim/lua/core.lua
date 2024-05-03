local opt = vim.opt
local options = {
    -- disable the -- STATUS -- line
    showmode = false,
    showtabline = 0,
    startofline = true, -- motions like "G" also move to the first char
    virtualedit = 'block', -- visual-block mode can select beyond end of line
    showmatch = true, -- when closing a bracket, briefly flash the matching one
    matchtime = 1, -- duration of that flashing n deci-seconds
    signcolumn = 'yes:1', -- static width
    report = 9001, -- disable "x more/fewer lines" messages
}

-- iterate over the options table and set the options
-- for each key = value pair
for key, value in pairs(options) do
    opt[key] = value
end

if not vim.g.vscode then
    opt.timeoutlen = 300 -- Time out on mappings
end
