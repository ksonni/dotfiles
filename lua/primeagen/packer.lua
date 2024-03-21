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

end)

