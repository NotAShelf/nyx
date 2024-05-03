if vim.g.neovide then
  local vks = vim.keymap.set

  vim.g.neovide_scale_factor = 1.0
  vim.g.minianimate_disable = true
  vim.g.neovide_window_blurred = true
  vim.g.neovide_transparency = 0.80
  vim.g.neovide_show_border = true
  vim.g.neovide_input_macos_alt_is_meta = true
  vim.g.neovide_cursor_animate_command_line = false -- noice incompat
  vim.g.neovide_cursor_smooth_blink = true
  vim.g.neovide_cursor_vfx_mode = 'ripple'

  -- keymaps
  vks('v', '<D-c>', '"+y') -- Copy
  vks({ 'n', 'v' }, '<D-v>', '"+P') -- Paste
  vks({ 'i', 'c' }, '<D-v>', '<C-R>+') -- Paste
  vks('t', '<D-v>', [[<C-\><C-N>"+P]]) -- Paste
  vks('n', '<D-+>', function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.1
  end)
  vks('n', '<D-->', function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor / 1.1
  end)
  vks({ 'n', 'v', 't', 'i' }, '<D-}>', [[<C-\><C-N><Cmd>tabnext<CR>]])
  vks({ 'n', 'v', 't', 'i' }, '<D-{>', [[<C-\><C-N><Cmd>tabprev<CR>]])
  vks({ 'n', 'v', 't', 'i' }, '<D-l>', [[<C-\><C-N><Cmd>tabnext #<CR>]])
  vks({ 'n', 'v', 't', 'i' }, '<D-t>', [[<C-\><C-N><Cmd>tabnew<CR>]])
  vks({ 'n', 'v', 't', 'i' }, '<D-w>', [[<C-\><C-N><Cmd>tabclose<CR>]])
end
