" Load plugins.
runtime ./plug.vim

" The most important keys should be easier to reach.
" Also avoid some of the most common typos.
let mapleader=" "
nnoremap . :
nnoremap ; :
nnoremap q: <nop>
nnoremap Q: <nop>
map q <Nop>
inoremap <C-e> <Esc>
command! -bang -range=% -complete=file -nargs=* W <line1>,<line2>write<bang> <args>
command! -bang Q quit<bang>

" Faster navigation and file handling.
" Manage buffers.
map <leader>d :bp\|bd #<cr>
nnoremap <leader>D :ls<cr>:bd<space>
" Manage windows.
map <C-Up> <C-w>k
map <C-Down> <C-w>j
map <C-Left> <C-w>h
map <C-Right> <C-w>l

" Layout.
set cursorline
set noruler
set number relativenumber
set scrolloff=10
set signcolumn=yes

" Colors.
set pumblend=5
set termguicolors
colorscheme gruvbox
hi Normal guibg=NONE
hi LineNr guibg=NONE
hi SignColumn guibg=NONE
hi EndOfBuffer guifg=#282828

" Whitespace.
set expandtab
set shiftwidth=2
set smartindent
set tabstop=2

" Folding.
set foldmethod=indent
set foldlevelstart=20

" Search and replace.
set inccommand=split
set smartcase
nnoremap <C-h> :noh<cr>

" Copy and paste.
set clipboard=unnamedplus
autocmd InsertLeave * set nopaste

" Wrapping.
set list listchars=extends:>,precedes:<
set nowrap
" https://vim.fandom.com/wiki/Move_cursor_by_display_lines_when_wrapping
noremap <silent> <leader>w :call ToggleWrap()<cr>
function ToggleWrap()
  if &wrap
    echo "Wrap OFF"
    setlocal nowrap
    set virtualedit=all
    silent! nunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Home>
    silent! nunmap <buffer> <End>
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
  else
    echo "Wrap ON"
    setlocal wrap linebreak nolist
    set virtualedit=
    setlocal display+=lastline
    noremap  <buffer> <silent> <Up>   gk
    noremap  <buffer> <silent> <Down> gj
    noremap  <buffer> <silent> <Home> g<Home>
    noremap  <buffer> <silent> <End>  g<End>
    inoremap <buffer> <silent> <Up>   <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
    inoremap <buffer> <silent> <Home> <C-o>g<Home>
    inoremap <buffer> <silent> <End>  <C-o>g<End>
  endif
endfunction
" These filetypes should wrap by default.
au FileType latex    setlocal wrap
au FileType markdown setlocal wrap
au FileType text     setlocal wrap

" Miscellaneous.
set backspace=indent,eol,start
set nobackup
set path+=**
set updatetime=100
set wildignore+=*/git/*
set wildignorecase

" FZF.
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>f :Files<cr>
nnoremap <leader>g :Rg<cr>

" Gitgutter.
set foldtext=gitgutter#fold#foldtext()
let g:gitgutter_highlight_linenrs=1
let g:gitgutter_set_sign_backgrounds=0
let g:gitgutter_sign_modified_removed='≈'
hi GitGutterAdd guifg=#8ec07c
hi GitGutterChange guifg=#fabd2f
hi GitGutterDelete guifg=#fb2934
hi GitGutterChangeDelete guifg=#fb2934
hi link GitGutterAddLineNr GitGutterAdd
hi link GitGutterChangeLineNr GitGutterChange
hi link GitGutterDeleteLineNr GitGutterDelete
hi link GitGutterChangeDeleteLineNr GitGutterChangeDelete

" Lualine.
lua << END
require('lualine').setup({
  options = { globalstatus = true },
  sections = {
    lualine_x = {'filetype'}
  }
})
END

" Neotree.
nnoremap <C-n> :Neotree toggle float<cr>
lua << END
require('neo-tree').setup({
  filesystem = {
    filtered_items = { visible = true },
    sort_case_insensitive = true
  }
})
END

" Tagbar.
nmap <C-t> :TagbarToggle<cr>
