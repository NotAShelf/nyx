"vi:filetype=vim

" add ~/.vim to the beginning of the runtimepath
set runtimepath^=~/.vim

" set the packpath to the runtimepath
let &packpath = &runtimepath

" for plugins to load correctly
filetype plugin indent on

" don't try to be vi compatible
set nocompatible

" use system clipboard
set clipboard+=unnamedplus

" syntax highlighting
syntax enable

" display line numbers
set number relativenumber

" enable mouse support in all modes
set mouse=a

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


" spaces instead of tabs for indentation
set expandtab

" 'smart' tabs that respects 'shiftwidth' for indentation
set smarttab

" number of spaces a <Tab> in the file counts for
set tabstop=4

" number of spaces to use for each step of (auto)indent
set shiftwidth=0

" define backspace behavior in insert mode:
" - 'indent': allows backspace to delete auto-indentation at the start of a line
" - 'eol': enables backspace to delete the end-of-line character, acting as line deletion
" - 'start': allows backspace to delete past the start of insert or typeahead
set backspace=indent,eol,start


" spell Checking
set spelllang=en " spell check langs
set spellsuggest=best,9  " suggestions for spelling corrections

