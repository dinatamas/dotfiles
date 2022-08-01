call plug#begin()

" Appearance.
Plug 'morhetz/gruvbox'
Plug 'nvim-lualine/lualine.nvim'
Plug 'ryanoasis/vim-devicons'

" Navigation.
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'preservim/tagbar'

" File explorer.
Plug 'nvim-lua/plenary.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-neo-tree/neo-tree.nvim'

" Git utilities.
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" LSPs, linters, formatters.
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'neovim/nvim-lspconfig'
Plug 'onsails/lspkind.nvim'
Plug 'williamboman/mason.nvim'

" File syntax extensions.
Plug 'dag/vim-fish'

call plug#end()
