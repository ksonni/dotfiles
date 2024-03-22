vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- file finder
  use {
      'nvim-telescope/telescope.nvim', tag = '0.1.4', 
      requires = { {'nvim-lua/plenary.nvim'} }
  }
	
  -- color scheme
  use({
      'rose-pine/neovim',
      as = 'rose-pine',
      config = function()
	  vim.cmd('colorscheme rose-pine')
      end
  })

  -- syntax highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
        local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
	ts_update()
    end
  }
 
  -- tabless navigation
  use('theprimeagen/harpoon')

  -- undo history
  use('mbbill/undotree')

  -- git history
  use("tpope/vim-fugitive")

  -- lsp
  use {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v1.x',
	  requires = {
		  -- LSP Support
		  {'neovim/nvim-lspconfig'},
		  {'williamboman/mason.nvim'},
		  {'williamboman/mason-lspconfig.nvim'},

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},
		  {'hrsh7th/cmp-buffer'},
		  {'hrsh7th/cmp-path'},
		  {'saadparwaiz1/cmp_luasnip'},
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'hrsh7th/cmp-nvim-lua'},

		  -- Snippets
		  {'L3MON4D3/LuaSnip'},
		  {'rafamadriz/friendly-snippets'},
	  }
  }

end)

