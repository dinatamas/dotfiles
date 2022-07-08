" Make life easier on non-US keyboards.
let mapleader=","
nnoremap . :
nnoremap ; :
nnoremap q: <nop>
nnoremap Q: <nop>
map q <Nop>

" Tired of pressing Esc all the time.
inoremap jj <Esc>

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

"
" The following is copy-pasted!
"

nnoremap <S-C-p> "0p
" Delete without yank
nnoremap <leader>d "_d
nnoremap x "_x

" Increment/decrement
nnoremap + <C-a>
nnoremap - <C-x>

" Select all
nmap <C-a> gg<S-v>G

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" Open current directory
nmap te :tabedit 
nmap <S-Tab> :tabprev<Return>
nmap <Tab> :tabnext<Return>

" Split window
nmap ss :split<Return><C-w>w
nmap sv :vsplit<Return><C-w>w
" Move window
nmap <Space> <C-w>w
map s<left> <C-w>h
map s<up> <C-w>k
map s<down> <C-w>j
map s<right> <C-w>l
map sh <C-w>h
map sk <C-w>k
map sj <C-w>j
map sl <C-w>l
" Resize window
nmap <C-w><left> <C-w><
nmap <C-w><right> <C-w>>
nmap <C-w><up> <C-w>+
nmap <C-w><down> <C-w>-

