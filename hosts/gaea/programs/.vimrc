		" use vim settings, rather than vi settings
        " must be first, because it changes other options as a side effect
        set nocompatible
        " security
        set modelines=0

        " hide buffers, not close them
        set hidden

        set noswapfile

        " lazy file name tab completion
        set wildmode=longest,list,full
        set wildmenu
        set wildignorecase
        " ignore files vim doesnt use
        set wildignore+=.git,.hg,.svn
        set wildignore+=*.aux,*.out,*.toc
        set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest,*.rbc,*.class
        set wildignore+=*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp
        set wildignore+=*.avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,*.mkv,*.vob,*.mpg,*.mpeg
        set wildignore+=*.mp3,*.oga,*.ogg,*.wav,*.flac
        set wildignore+=*.eot,*.otf,*.ttf,*.woff
        set wildignore+=*.doc,*.pdf,*.cbr,*.cbz
        set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.kgb
        set wildignore+=*.swp,.lock,.DS_Store,._*

        " case insensitive search
        set ignorecase
        set smartcase
        set infercase

        set hlsearch
        set incsearch

        " make backspace behave in a sane manner
        set backspace=indent,eol,start

        " indent is 4 spaces, a law of nature
        set shiftwidth=2

        " tabs are spaces, not tabs
        set expandtab

        " an indentation every four columns
        set tabstop=2

        " let backspace delete indent
        set softtabstop=2

        " enable auto indentation
        set autoindent

        " remove trailing whitespaces and ^M chars
        autocmd FileType c,cpp,java,php,js,ts,tsx,json,python,twig,xml,yml autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))

        " take me to your leader, whose name i know is ,
        let mapleader=","
        vnoremap <silent> <leader>y :w !xsel -i -b<CR>
        nnoremap <silent> <leader>y V:w !xsel -i -b<CR>
        nnoremap <silent> <leader>p :silent :r !xsel -o -b<CR>

        " remove trailing white space
        command Nows :%s/\s\+$//

        " remove blank lines
        command Nobl :g/^\s*$/d

        " toggle spellcheck
        command Spell :setlocal spell! spell?

        " true colors are the right colors
        set termguicolors
        colorscheme gruvbox

        " gruvbox colors for the discerning cowboy coder
        set background=dark
        let g:gruvbox_italic=1
        let g:gruvbox_contrast_dark = 'hard'
        colorscheme gruvbox


        " show matching brackets/parenthesis
        set showmatch

        " disable startup message
        set shortmess+=I

        " syntax highlighting
        syntax on
        set synmaxcol=512
        filetype off

        " stop unnecessary rendering
        set lazyredraw

        " show line numbers
        set number

        " no line wrapping
        set nowrap

        " do not fold. repeat. do not fold.
        set nofoldenable
        set foldlevel=99
        set foldminlines=99
        set foldlevelstart=99

        " where am i? highlight cursor
        set cursorline
        "set cursorcolumn

        " and let the invisibles be seen and known once more
        set list
        set listchars=
        set listchars+=tab:𐄙\
        set listchars+=trail:·
        set listchars+=extends:»
        set listchars+=precedes:«
        set listchars+=nbsp:⣿

        " UI Config

        "" These are options that changes random visuals in Vim
        syntax on
        filetype on
        set number                       " show line numbers
        set showcmd                      " show command in bottom bar
        set tw=0                         " hard wrap disabled
        set nowrap                       " don't automatically wrap on load
        set smartindent
        set colorcolumn=80
        set visualbell                   " don't beep
        set noerrorbells                 " don't beep
        set autowrite                    " Save on buffer switch
        set mouse+=a
        set encoding=utf-8
        set cursorline                   " highlight current line
        set lazyredraw                   " redraw only when we need to
        set showmatch                    " highlight matching [{()}]
        set autoindent
        set expandtab
        set splitbelow
        set splitright
        set spell                        " Turn on spell checker
        set spellsuggest=5               " Limit the number of suggested words

        " System clipboard
        " cut/copy/paste to/from other application
        set clipboard=unnamed     " access your system clipboard
        set pastetoggle=<F2>


        "" easier moving of code blocks
        "" Try to go into visual mode (v), thenselect several lines of code here and
        "" then press ``>`` several times.
        vnoremap < <gv              " better indentation
        vnoremap > >gv              " better indentation

        set backupcopy=yes
