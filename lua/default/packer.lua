local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local should_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    -- Packer can manage itself
    use { 'wbthomason/packer.nvim', commit = 'ea0cc3c5' }

    -- File finder
    use {
        'nvim-telescope/telescope.nvim',
        commit = "b4da76b",
        requires = {
            { 'nvim-lua/plenary.nvim', commit = "b9fd522" },
        },
    }

    -- Color scheme
    use {
        'Mofiqul/dracula.nvim',
        as = 'dracula',
        commit = '041d923',
    }

    -- Syntax highlighting
    use {
        'nvim-treesitter/nvim-treesitter',
        commit = '42fc28b',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end
    }

    -- Tabless navigation
    use { 'theprimeagen/harpoon', commit = '1bc17e3' }

    -- Git history
    use { 'tpope/vim-fugitive', commit = '61b51c0' }

    -- LSP
    use { 'neovim/nvim-lspconfig', commit = '1f7fbc3' }
    use { 'williamboman/mason.nvim', comit = '7dc4fac' }
    use { 'williamboman/mason-lspconfig.nvim', commit = '7f9a39f' }

    -- Completions
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            -- Autocompletion
            { 'hrsh7th/cmp-nvim-lsp',         commit = 'bd5a7d6' },
            { 'hrsh7th/cmp-buffer',           commit = 'b74fab3' },
            { 'hrsh7th/cmp-path',             commit = 'c642487' },
            { 'hrsh7th/cmp-cmdline',          commit = 'd126061' },
            { 'hrsh7th/cmp-nvim-lua',         commit = 'f12408b' },

            -- Snippets
            { 'saadparwaiz1/cmp_luasnip',     commit = '98d9cb5' },
            { 'L3MON4D3/LuaSnip',             commit = 'b310491' },
            { 'rafamadriz/friendly-snippets', commmit = '572f566' },
        },
    }

    -- Bracket closing
    use { 'windwp/nvim-autopairs', commit = '23320e7' }

    -- Commenting
    use {
        'numToStr/Comment.nvim',
        commit = 'e30b7f2',
        config = function()
            require('Comment').setup()
        end
    }

    -- Code folidng
    use {
        'kevinhwang91/nvim-ufo',
        commit = 'd31e2a9',
        requires = { 'kevinhwang91/promise-async', commit = '119e896' },
    }

    -- Status line
    use {
        'nvim-lualine/lualine.nvim',
        commit = 'b8c2315',
        requires = { 'nvim-tree/nvim-web-devicons', commit = '6e51ca1', opt = true }
    }

    -- LSP progress in status line
    use {
        'linrongbin16/lsp-progress.nvim',
        commit = 'f61cb7a',
        config = function()
            require('lsp-progress').setup()
        end
    }

    if should_bootstrap then
        require('packer').sync()
    end
end)
