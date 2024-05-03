-- luacheck: ignore
vim.opt_local.textwidth = 80

local CR = vim.api.nvim_replace_termcodes('<cr>', true, true, true)
local function toggle_checkbox()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local lineno = cursor[1]
  local line = vim.api.nvim_buf_get_lines(0, lineno - 1, lineno, false)[1] or ''
  if string.find(line, '%[ %]') then
    line = line:gsub('%[ %]', '%[x%]')
  else
    line = line:gsub('%[x%]', '%[ %]')
  end
  vim.api.nvim_buf_set_lines(0, lineno - 1, lineno, false, { line })
  vim.api.nvim_win_set_cursor(0, cursor)
  pcall(vim.fn['repeat#set'], ':ToggleCheckbox' .. CR)
end

vim.api.nvim_create_user_command(
  'ToggleCheckbox',
  toggle_checkbox,
  vim.tbl_extend('force', { desc = 'toggle checkboxes' }, {})
)

vim.keymap.set('n', '<leader>op', toggle_checkbox, {
  noremap = true,
  silent = true,
  desc = 'Toggle checkbox',
  buffer = 0,
})
