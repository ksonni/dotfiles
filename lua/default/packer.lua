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

-- NOTE: pin plugin commits instead of tags because several upstream tags lag behind
return require('packer').startup(function(use)
    -- Packer can manage itself
    use { 'wbthomason/packer.nvim', commit = 'ea0cc3c5' }

    -- File finder
    use {
        'nvim-telescope/telescope.nvim',
        commit = '40aedd8',
        requires = {
            { 'nvim-lua/plenary.nvim', commit = '74b06c6' },
        },
    }

    -- Color scheme
    use {
        'Mofiqul/dracula.nvim',
        as = 'dracula',
        commit = 'ae752c1',
    }

    -- Syntax highlighting
    use {
        'nvim-treesitter/nvim-treesitter',
        commit = '857651f',
        run = ':TSUpdate',
    }

    -- Tabless navigation
    use {
        'theprimeagen/harpoon',
        commit = '87b1a35',
        requires = { { 'nvim-lua/plenary.nvim', commit = '74b06c6' } },
    }

    -- Git history
    use { 'tpope/vim-fugitive', commit = '3b753cf' }

    -- LSP
    use { 'neovim/nvim-lspconfig', commit = '684cb45' }
    use { 'williamboman/mason.nvim', commit = '2a6940a' }
    use { 'williamboman/mason-lspconfig.nvim', commit = '40276c4' }

    -- Completions
    use {
        'hrsh7th/nvim-cmp',
        commit = '2ffe79f',
        requires = {
            -- Autocompletion
            { 'hrsh7th/cmp-nvim-lsp',         commit = 'cbc7b02' },
            { 'hrsh7th/cmp-buffer',           commit = 'b74fab3' },
            { 'hrsh7th/cmp-path',             commit = 'c642487' },
            { 'hrsh7th/cmp-cmdline',          commit = 'd126061' },
            { 'hrsh7th/cmp-nvim-lua',         commit = 'e3a22cb' },

            -- Snippets
            { 'saadparwaiz1/cmp_luasnip',     commit = '98d9cb5' },
            { 'L3MON4D3/LuaSnip',             commit = '0abc8f3' },
            { 'rafamadriz/friendly-snippets', commit = '6cd7280' },
        },
    }

    -- Bracket closing
    use { 'windwp/nvim-autopairs', commit = '430522f' }

    -- Code folidng
    use {
        'kevinhwang91/nvim-ufo',
        commit = 'ab3eb12',
        requires = { 'kevinhwang91/promise-async', commit = '119e896' },
    }

    -- Status line
    use {
        'nvim-lualine/lualine.nvim',
        commit = '221ce6b',
        requires = { 'nvim-tree/nvim-web-devicons', commit = '2ae6958', opt = true }
    }

    -- LSP progress in status line
    use {
        'linrongbin16/lsp-progress.nvim',
        commit = 'f6d5af1',
        config = function()
            require('lsp-progress').setup()
        end
    }

    -- Markdown preview (browser-based, with Mermaid support)
    use {
        'iamcco/markdown-preview.nvim',
        commit = 'a923f5fc',
        run = function()
            vim.fn["mkdp#util#install"]()
            local plugin_dir = vim.fn.stdpath('data') .. '/site/pack/packer/opt/markdown-preview.nvim'
            local patch = vim.fn.stdpath('config') .. '/patches/markdown-preview-page.css.diff'
            local out = vim.fn.system('patch -d ' .. plugin_dir .. ' -p1 --forward < ' .. patch)
            if vim.v.shell_error ~= 0 then
                error('markdown-preview patch failed:\n' .. out)
            end
        end,
        ft = { 'markdown', 'mermaid' },
    }

    if should_bootstrap then
        require('packer').sync()
    end
end)
