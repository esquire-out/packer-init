-- Mappings
vim.g.mapleader = ' '
vim.api.nvim_set_keymap('n', '<leader>b', ':BufferPick<CR>', {
    noremap = true,
    silent = true,
    desc = 'Enter [B]ufferPick mode'
})

-- toggle both numbers and relativenumbers on, vim.cmd
vim.cmd('set number relativenumber')

-- Telescope Mappings
vim.api.nvim_set_keymap('n', 'T', ':Telescope<CR>',{
    noremap = true,
    silent = true,
    desc = 'Launch [T]elescope'
})

vim.api.nvim_set_keymap('n', 'F', ':Telescope find_files<CR>', { 
    noremap = true,
    silent = true,
    desc = 'Find [F]iles'
})

vim.api.nvim_set_keymap('n', 'B', ':Telescope buffers<CR>', {
    noremap = true,
    silent = true,
    desc = 'Search in current [B]uffer'
})

-- Options
vim.opt.textwidth = 80

-- tab width
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Plugins
require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	-- Theme
	use 'folke/tokyonight.nvim'
	vim.cmd('colorscheme tokyonight-night')
    
    -- barbar
    use 'romgrk/barbar.nvim'

    -- LuaLine
    use {
        'nvim-lualine/lualine.nvim',
        requires = {'nvim-tree/nvim-web-devicons', opt = true}
    }

	-- Treesitter
	use 'nvim-treesitter/nvim-treesitter'

	-- Mason
	use {
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'neovim/nvim-lspconfig',
	}

	-- Telescope
	use {
		'nvim-telescope/telescope.nvim',
		tag = '0.1.0',
		requires = {{ 'nvim-lua/plenary.nvim' }}
	}
    
    -- Autocompletion
    use 'hrsh7th/nvim-cmp' -- nvim-cmp
    use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
    use 'hrsh7th/cmp-buffer' -- buffer source for nvim-cmp
    use 'L3MON4D3/LuaSnip' -- Snippets engine
    use 'saadparwaiz1/cmp_luasnip' -- LuaSnip source for nvim-cmp

    -- Not copilot
    use 'github/copilot.vim'
end)


-- LSP stuff
require('mason').setup()
require('mason-lspconfig').setup({
	ensure_installed = { 'lua_ls' }

})

local on_attach = function(_, _)
	-- No idea what these do
	--vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
	vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
	-- These I know 
    vim.keymap.set('n', 'E', vim.diagnostic.open_float, {})
	vim.keymap.set('n', '<leader>i', vim.lsp.buf.implementation, {})
	vim.keymap.set('n', '<leader>r', require('telescope.builtin').lsp_references, {})
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
end

require('lspconfig').lua_ls.setup {
	on_attach = on_attach
}

-- Server configurations
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

-- Configures mason based on the servers table (?)
mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

-- Configures the handlers for each server
mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}
-- End LSP stuff
local cmp = require('cmp')
local luasnip = require('luasnip')

luasnip.config.setup {}
-- nvim-cmp setup
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  -- cmp Mappings
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete({}),
    ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true,}),
    ['<Down>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<Up>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    -- { name = 'mason' },
  },
}


require('lualine').setup {
    options = {
        theme = 'tokyonight'
    }
}


-- Must always be at end of file 
require('copilot').setup()

