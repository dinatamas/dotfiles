" Source:
" https://dane-bulat.medium.com/how-to-turn-vim-into-a-lightweight-ide-6185e0f47b79

" ------------------------------------------------------------
" Load plugins
" ------------------------------------------------------------

set nocompatible
filetype off

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

" Plugins will be downloaded under the specified directory.
call vundle#begin('~/.vim/plugged')

" Let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Colorschemes
Plugin 'kristijanhusak/vim-hybrid-material'
Plugin 'cocopon/iceberg.vim'
Plugin 'arcticicestudio/nord-vim'
Plugin 'sjl/badwolf'
Plugin 'lifepillar/vim-solarized8'
Plugin 'scheakur/vim-scheakur'
Plugin 'Badacadabra/vim-archery'
Plugin 'morhetz/gruvbox'

" PloyGlot
Plugin 'sheerun/vim-polyglot'

" Auto Pairs
Plugin 'jiangmiao/auto-pairs'   " Auto Pairs

" NERDTree
Plugin 'preservim/nerdtree'

" Tagbar
Plugin 'preservim/tagbar'

" ctrlsf.vim 
Plugin'dyng/ctrlsf.vim'

" vim-fswitch
Plugin 'derekwyatt/vim-fswitch'

" vim-protodef 
Plugin 'derekwyatt/vim-protodef'

" List ends here. Plugins become visible to Vim after this call.
call vundle#end()
filetype plugin indent on


" ------------------------------------------------------------
" auto-pairs configuration
" ------------------------------------------------------------

let g:AutoPairsShortcutToggle = '<C-P>'


" ------------------------------------------------------------
" NERDTree configuration
" ------------------------------------------------------------

let NERDTreeShowBookmarks = 1
let NERDTreeShowHidden = 1
let NERDTreeShowLineNumbers = 0
let NERDTreeMinimalMenu = 1
let NERDTreeWinPos = "left"
let NERDTreeWinSize = 31


" ------------------------------------------------------------
" tagbar configuration
" ------------------------------------------------------------

let g:tagbar_autofocus = 1
let g:tagbar_autoshowtag = 1
let g:tagbar_position = 'botright vertical'


" ------------------------------------------------------------
" ctrlsf configuration
" ------------------------------------------------------------

let g:ctrlsf_backend = 'ack'
let g:ctrlsf_auto_close = { "normal": 0, "compact": 0 }
let g:ctrlsf_auto_focus = { "at": "start" }
let g:ctrlsf_auto_preview = 0
let g:ctrlsf_case_sensitive = 'smart'
let g:ctrlsf_default_view = 'normal'
let g:ctrlsf_regex_pattern = 0
let g:ctrlsf_position = 'right'
let g:ctrlsf_winsize = '46'
let g:ctrlsf_default_root = 'cwd'   " projcet


" ------------------------------------------------------------
" fswitch configuration
" ------------------------------------------------------------
"
" Set fswichdst and fswitchloc variables when BufEnter event takes place
" on a file whose name matches {*.cpp}.

au! BufEnter *.cpp let b:fswitchdst = 'hpp,h'
au! BufEnter *.h   let b:fswitchdst = 'cpp,c'

" fswitchdst  - Denotes the files extensions that is the target extension of
"               the current file's companion file.
"
" fswitchlocs - Contains a set of directories that indicate directory names 
"               that should be formulated when trying to find the alternate
"               file.

" ------------------------------------------------------------
" vim-protodef configuration 
" ------------------------------------------------------------

nmap <buffer> <silent> <leader> ,PP
nmap <buffer> <silent> <leader> ,PN

" NOTE: This doesn't seem to disable the sorting.
let g:disable_protodef_sorting = 1


" ------------------------------------------------------------
" Vim configuration
" ------------------------------------------------------------

set nu                  " Enable line numbers
syntax on               " Enable synax highlighting
set incsearch           " Enable incremental search
set hlsearch            " Enable highlight search
set splitbelow          " Always split below"
set mouse=a             " Enable mouse drag on window splits
set tabstop=4           " How many columns of whitespace a \t is worth
set shiftwidth=4        " How many columns of whitespace a “level of indentation” is worth
set expandtab           " Use spaces when tabbing

if !has('nvim')
    set termwinsize=12x0    " Set terminal size
endif

" https://unix.stackexchange.com/a/612641
if has("termguicolors")
  set termguicolors
  if &t_8f == ''
    " The first characters after the equals sign are literal escape characters.
    set t_8f=\\033[38;2;%lu;%lu;%lum
    set t_8b=\\033[48;2;%lu;%lu;%lum
  endif
endif

set background=light     " Set background
colorscheme gruvbox
hi Normal ctermbg=NONE guibg=NONE
hi LineNr ctermbg=NONE guibg=NONE
hi StatusLine ctermbg=NONE guibg=NONE gui=NONE guifg=#3c3836

" ------------------------------------------------------------
" Key mappings
" ------------------------------------------------------------

" General
nmap        <C-B>     :buffers<CR>
nmap        <C-J>     :term<CR>

" NERDTree
nmap        <F2>      :NERDTreeToggle<CR>
" https://stackoverflow.com/a/16505009
nnoremap <C-B>q :bp<cr>:bd #<cr>
nnoremap <C-B>p :bp<cr>
nnoremap <C-B>n :bn<cr>

" tagbar
nmap        <F8>      :TagbarToggle<CR>

" ctrlds
nmap        <C-F>f    <Plug>CtrlSFPrompt
xmap        <C-F>f    <Plug>CtrlSFVwordPath
xmap        <C-F>F    <Plug>CtrlSFVwordExec
nmap        <C-F>n    <Plug>CtrlSFCwordPath
nmap        <C-F>p    <Plug>CtrlSFPwordPath
nnoremap    <C-F>o    :CtrlSFOpen<CR>
nnoremap    <C-F>t    :CtrlSFToggle<CR>
inoremap    <C-F>t    <Esc>:CtrlSFToggle<CR>

" fswitch
nmap        <C-Z>     :vsplit <bar> :wincmd l <bar> :FSRight<CR>

" ------------------------------------------------------------
" Extra configs
" ------------------------------------------------------------

" Show row, column in statusbar
set ruler

" Help with proper columning
highlight ColorColumn ctermbg=7 guifg=#d5c4a1 guibg=#bdae93
set colorcolumn=80,100

" Highlighting stuff!
" Other options: for,while,if,elif,else,try,except,with
hi Sep cterm=underline,italic gui=underline,italic
autocmd BufNewFile,BufRead *.py
    \ match Sep "^[ \t]*\zs\(\(def\|
    \class\).*:\|\(return\|yield\).*\)
    \\ze[ \t ]*\(#.*\)\?$"

set ignorecase

" TODO: Automatically toggle paste mode & autoindent.
set clipboard+=unnamedplus
