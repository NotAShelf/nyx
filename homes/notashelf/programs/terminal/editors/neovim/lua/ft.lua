-- luacheck: ignore
vim.g.markdown_fenced_languages = { 'shell=bash' }

local file_syntax_map = {
  { pattern = '*.rasi', syntax = 'scss' },
  { pattern = 'flake.lock', syntax = 'json' },
  { pattern = '*.ignore', syntax = 'gitignore' }, -- also ignore for fd/ripgrep
}

for _, elem in ipairs(file_syntax_map) do
  vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = elem.pattern,
    command = 'set syntax=' .. elem.syntax,
  })
end
