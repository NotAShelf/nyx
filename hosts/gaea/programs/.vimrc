" set indentation to spaces instead of tabs
set noexpandtab

" number of spaces to use for each step of (auto)indent
set shiftwidth=2

" number of spaces that a <Tab> in the file counts for
set tabstop=2

" C-style indenting
set cindent

" 'smart' indenting
set smartindent

" set the indent of new lines
set autoindent

" set the folding method based on syntax
set foldmethod=syntax

" map key <F2> to toggle between hiding/showing current line
nmap <F2> zA

" map key <F3> to toggle between reducing/enlarging fold level
nmap <F3> zR

" map key <F4> to fold everything except the cursor line
nmap <F4> zM

" syntax highlighting
syntax enable
