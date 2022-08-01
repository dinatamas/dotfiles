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
command! -bang Q close<bang>
command! -bang Quit quit<bang>
cabbrev q <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'close' : 'q')<CR>

" Faster navigation and file handling.
" Manage buffers.
map <leader>d :bp\|bd #<cr>
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

" FZF
let g:fzf_command_prefix='Fzf'
nnoremap <leader>b :FzfBuffers<cr>
nnoremap <leader>f :FzfFiles<cr>
nnoremap <leader>g :FzfRg<cr>
nnoremap <leader>t :FzfTags<cr>
" The following enables multi-select buffer deletion.
" It is almost entirely copy-pasted from the :Buffers command.
" Use Tab to mark multiple buffers.
function! FzfBufferDelete(lines)
  for line in a:lines
    let b = matchstr(line, '\[\zs[0-9]*\ze\]')
    execute 'bd' b
  endfor
endfunction
function! FzfBuffersDelete(...)
  let [query, args] = (a:0 && type(a:1) == type('')) ? [a:1, a:000[1:]] : ['', a:000]
  let sorted = fzf#vim#_buflisted_sorted()
  let header_lines = '--header-lines=' . (bufnr('') == get(sorted, 0, 0) ? 1 : 0)
  let tabstop = len(max(sorted)) >= 4 ? 9 : 8
  return fzf#run(fzf#wrap('bufferdelete', {
  \ 'source':  map(sorted, 'fzf#vim#_format_buffer(v:val)'),
  \ 'sink*':   function('FzfBufferDelete'),
  \ 'options': ['--multi', '-x', '--tiebreak=index', header_lines, '--ansi', '-d',
  \             '\t', '--with-nth', '3..', '-n', '2,1..2', '--prompt', 'Buf> ',
  \             '--query', query, '--preview-window', '+{2}-/2', '--tabstop', tabstop]
  \}))
endfunction
command! -bar -bang -nargs=? -complete=buffer FzfBuffersDeleteCmd
  \ call FzfBuffersDelete(<q-args>, fzf#vim#with_preview({ "placeholder": "{1}" }), <bang>0)
nnoremap <leader>D :FzfBuffersDeleteCmd<cr>

" Gitgutter
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

" Lualine
lua << END
require('lualine').setup({
  options = { globalstatus = true },
  sections = {
    lualine_x = {'filetype'}
  }
})
END

" Mason
lua << END
require("mason").setup()
END

" Neotree
nnoremap <C-n> :Neotree toggle float<cr>
lua << END
require('neo-tree').setup({
  filesystem = {
    filtered_items = { visible = true },
    sort_case_insensitive = true
  }
})
END

" LSPs, linters, formatters.
set completeopt=menuone,noinsert,noselect,preview
nnoremap <C-n> <nop>
inoremap <C-n> <nop>
nnoremap <C-p> <nop>
inoremap <C-p> <nop>
lua << END
local cmp = require('cmp')
local lspkind = require('lspkind')
cmp.setup({
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-n>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-p>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-e>'] = cmp.mapping.abort()
  },
  sources = cmp.config.sources(
    {{ name = 'nvim_lsp' },},
    {{ name = 'nvim_lsp_signature_help' },},
    {{ name = 'buffer' },}
  ),
  formatting = {
    format = lspkind.cmp_format({with_text = false, maxwidth = 50})
  }
})
vim.cmd [[highlight! default link CmpItemKind CmpItemMenuDefault]]

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

require('lspconfig')['jedi_language_server'].setup({
  capabilities = capabilities
})
END

" Tagbar
nmap <C-t> :TagbarToggle<cr>
