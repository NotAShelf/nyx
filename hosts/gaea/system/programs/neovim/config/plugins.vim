" customize label for vim-sneak
let g:sneak#label = 1

" Toggle spell checking in normal mode
nnoremap <silent> <F3> :set spell!<CR>

" Toggle spell checking in insert mode
inoremap <silent> <F3> <C-O>:set spell!<CR>

lua << EOF
require('nvim-treesitter.configs').setup {
	highlight = {
		enable = true
    }
}
EOF
