"
" Minimalist neovim configuration.
"
" Sources:
"  - https://github.com/changemewtf/no_plugins/blob/master/no_plugins.vim
"  - https://www.youtube.com/watch?v=XA2WjJbmmoM
"  - https://blog.jez.io/vim-as-an-ide/
"  - https://dane-bulat.medium.com/how-to-turn-vim-into-a-lightweight-ide-6185e0f47b79
"
" Some key mappings:
"  - zz: Center the current line.
"  - https://www.how-hard-can-it.be/advanced-vim/
"  - https://github.com/ms-jpg/coq_nvim
"
" TODO: Show lines longer than 80 characters!
"

" Plugins
filetype off
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin('~/.config/nvim/plugged')

Plugin 'VundleVim/Vundle.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'morhetz/gruvbox'
Plugin 'preservim/nerdtree'

" File type support.
Plugin 'dag/vim-fish'
Plugin 'tomlion/vim-solidity'

call vundle#end()
filetype plugin indent on

" General configuration
set backspace=indent,eol,start
set clipboard=unnamedplus
set expandtab
set hlsearch
set ignorecase
set incsearch
set number
set ruler
set shiftwidth=4
set showcmd
set tabstop=4
syntax on

" Make life easier on non-US keyboards.
let mapleader=","
nnoremap . :
nnoremap ; :
nnoremap q: <nop>
nnoremap Q: <nop>
" I know recording is cool but I never use it.
" https://stackoverflow.com/a/1527824
map q <Nop>

" Accept :W and :Q as well!
" https://stackoverflow.com/a/10590421
command! -bang -range=% -complete=file -nargs=* W <line1>,<line2>write<bang> <args>
command! -bang Q quit<bang>

" Tabs
"   - gn to open a new empty tab
"   - gt to go to the next tab
"   - gp to go to the previous tab
"   - #gt to go to tab number #
map gp :tabp<CR>
map gn :tabnew<CR>

" Open every window in a tab.
autocmd BufEnter * if winnr() > 1 | wincmd T | endif

" Open edits and finds in a tab.
" https://stackoverflow.com/a/20564623
cnoreabbrev <expr> e getcmdtype() == ":" && getcmdline() == 'e' ? 'tabe' : 'e'
cnoreabbrev <expr> f getcmdtype() == ":" && getcmdline() == 'f' ? 'tabf' : 'f'

" When you close a tab, go back to the first.
au TabClosed * :tabn 1

" https://unix.stackexchange.com/a/612641
if has("termguicolors")
  set termguicolors
  if &t_8f == ''
    " The first characters after the equal sign are literal escape characters.
    set t_8f=\\033[38;2;%lu;%lu;%lum
    set t_8b=\\033[48;2;%lu;%lu;%lum
  endif
endif

" Colorscheme
set background=dark
colorscheme gruvbox
hi Normal ctermbg=NONE guibg=NONE
hi LineNr ctermbg=NONE guibg=NONE
hi EndOfBuffer guifg=#282828

" Statusline
set statusline=%=%t\ \ ○\ \ %l\ :\ %v\ :\ %L

" Fuzzy search for files
"  - :find with tab and shift+tab completion
"  - down arrow to select completion
"  - place * at the start or end
set path=**
set wildmenu

" Fuzzy search for opened buffers
"  - :ls will list the current open files
"  - :b and write a unique subset of the filename

" Tag jumping
" Or use vim-easytags and tagbar?
"  - ^] to jump to tag under cursor
"  - g^] for ambiguous tags
"  - ^t to jump back up the tag stack
command! MakeTags !ctags -R .

" File browsing
"  - ? for help
"  - u to go up a level
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

let NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1

let NERDTreeMapOpenInTab='\r'
let NERDTreeCustomOpenArgs={'file':{'where': 't'}}

" If NerdTree is not shown, delete it!
autocmd FileType netrw setl bufhidden=delete

" CtrlP should open files in new tabs.
let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<2-LeftMouse>'],
    \ 'AcceptSelection("t")': ['<cr>'],
    \ }

" File type support.
au BufNewFile,BufRead *git/config,gitconfig setf gitconfig
