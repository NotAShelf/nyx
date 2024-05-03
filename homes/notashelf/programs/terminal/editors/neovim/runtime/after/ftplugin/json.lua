vim.keymap.set('n', '<leader>jf', '<cmd>%!jq<cr>', { noremap = true, silent = true, desc = 'Format with jq' })
vim.keymap.set('n', '<leader>jm', '<cmd>%!jq -c<cr>', { noremap = true, silent = true, desc = 'Minify with jq' })

-- add comma to the end of the line on new line
vim.keymap.set('n', 'o', function()
  local line = vim.api.nvim_get_current_line()

  local should_add_comma = string.find(line, '[^,{[]$')
  if should_add_comma then
    return 'A,<cr>'
  else
    return 'o'
  end
end, { buffer = true, expr = true })
