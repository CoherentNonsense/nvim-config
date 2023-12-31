call plug#begin(has('nvim') ? stdpath('data') . 'plugged' : '~/.vim/plugged')

Plug 'tpope/vim-sensible'

Plug 'coherentnonsense/nvim-blackcat'
Plug 'AlexvZyl/nordic.nvim', { 'branch': 'main' }

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.2' }

Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

call plug#end()

colorscheme blackcat
autocmd FileType markdown colorscheme nordic
set termguicolors

set shiftwidth=4
set autoindent
set expandtab
set number
set relativenumber
syntax on

" Keybindings
nnoremap ff <cmd>Telescope find_files<cr>
" navigating long lines
nnoremap j gj
nnoremap k gk

lua <<EOF
    require("mason").setup()
    require("mason-lspconfig").setup()

    -- Set up nvim-cmp.
    local cmp = require'cmp'
    local luasnip = require'luasnip'

    cmp.setup({
    snippet = {
      expand = function(args)
	luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
	-- ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	['<Tab>'] = cmp.mapping(function(fallback)
	    if cmp.visible() then
		cmp.select_next_item()
	    elseif luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
	    else
		fallback()
	    end
	end, { 'i', 's' }),
	['<S-Tab>'] = cmp.mapping(function(fallback)
	    if cmp.visible() then
		cmp.select_prev_item()
	    elseif luasnip.jumpable(-1) then
		luasnip.jump(-1)
	    else
		fallback()
	    end
	end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
	{ name = 'nvim_lsp' }, { name = 'vsnip' },
	}, {
	    { name = 'buffer' },
	})
    })

    -- Set up lspconfig.
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local lspconfig = require('lspconfig')
    lspconfig.clangd.setup {
	capabilities = capabilities
    }
    lspconfig.svls.setup {}
    lspconfig.tsserver.setup {}
    lspconfig.rust_analyzer.setup {}
    lspconfig.html.setup {}
EOF

