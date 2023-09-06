call plug#begin(has('nvim') ? stdpath('data') . 'plugged' : '~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'coherentnonsense/nvim-blackcat'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.2' }

Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

call plug#end()

colorscheme blackcat
set termguicolors

set shiftwidth=4
set autoindent
set number
set relativenumber
syntax on

lua << EOF
require("mason").setup()
require("mason-lspconfig").setup()
require("lspconfig").clangd.setup {}
EOF

" Shortcuts
nnoremap ff <cmd>Telescope find_files<cr>
