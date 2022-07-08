"
" Minimalist neovim configuration.
"

"
" Fundamentals
"

set autoindent
set backspace=indent,eol,start
set clipboard=unnamedplus
set cmdheight=1
set cursorline
set encoding=utf-8
set expandtab
set exrc
set fileencodings=utf-8
set formatoptions+=r
set hlsearch
set ignorecase
set inccommand=split
set incsearch
set laststatus=2
set lazyredraw
set nobackup
set noruler
set noshowcmd
set noshowmatch
set nowrap
set number relativenumber
set path+=**
set scrolloff=10
set shell=fish
set shiftwidth=2
set showmode
set smartcase
set smartindent
set smarttab
set tabstop=2
set title
set wildignore+=*/git/*
set wildmenu

autocmd!
scriptencoding utf-8
syntax on
autocmd InsertLeave * set nopaste
filetype plugin indent on

"
" Imports
"

runtime ./plug.vim
runtime ./maps.vim

" Folding.
" https://vi.stackexchange.com/a/31436
set foldmethod=indent
set foldlevelstart=20
set list listchars=extends:>,precedes:<

"
" Color scheme.
"

set background=dark
colorscheme solarized
hi Normal ctermbg=NONE guibg=NONE
hi LineNr ctermbg=NONE guibg=NONE
hi EndOfBuffer guifg=#282828

" https://unix.stackexchange.com/a/612641
if has("termguicolors")
  set termguicolors
  set pumblend=5
  set winblend=0
  set wildoptions=pum
  if &t_8f == ''
    set t_8f=\\033[38;2;%lu;%lu;%lum
    set t_8b=\\033[48;2;%lu;%lu;%lum
  endif
endif

"
" File types.
"

au BufNewFile,BufRead *.fish                 setf fish
au BufNewFile,BufRead *git/confuig,gitconfig setf gitconfig
au BufNewFile,BufRead *.md                   setf markdown

set suffixesadd=.json,.py,.md

" https://vi.stackexchange.com/q/88
au FileType latex    setlocal wrap
au FileType markdown setlocal wrap
au FileType txt      setlocal wrap
