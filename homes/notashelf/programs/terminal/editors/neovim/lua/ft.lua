-- luacheck: ignore
vim.filetype.add({
  filename = {
    ['.ignore'] = 'gitignore', -- also ignore for fd/ripgrep
  },
})
