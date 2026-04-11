local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git', 'clone', '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    -- File finder
    {
        'nvim-telescope/telescope.nvim',
        commit = 'b4da76b',
        dependencies = {
            { 'nvim-lua/plenary.nvim', commit = 'b9fd522' },
        },
    },

    -- Color scheme
    {
        'Mofiqul/dracula.nvim',
        name = 'dracula',
        commit = '041d923',
    },

    -- Syntax highlighting
    {
        'nvim-treesitter/nvim-treesitter',
        commit = '42fc28b',
        build = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    },

    -- Tabless navigation
    { 'theprimeagen/harpoon',              commit = '1bc17e3' },

    -- Git history
    { 'tpope/vim-fugitive',                commit = '61b51c0' },

    -- LSP
    { 'neovim/nvim-lspconfig',             commit = '1f7fbc3' },
    { 'williamboman/mason.nvim',           commit = '7dc4fac' },
    { 'williamboman/mason-lspconfig.nvim', commit = '7f9a39f' },

    -- Completions
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Autocompletion
            { 'hrsh7th/cmp-nvim-lsp',         commit = 'bd5a7d6' },
            { 'hrsh7th/cmp-buffer',           commit = 'b74fab3' },
            { 'hrsh7th/cmp-path',             commit = 'c642487' },
            { 'hrsh7th/cmp-cmdline',          commit = 'd126061' },
            { 'hrsh7th/cmp-nvim-lua',         commit = 'f12408b' },

            -- Snippets
            { 'saadparwaiz1/cmp_luasnip',     commit = '98d9cb5' },
            { 'L3MON4D3/LuaSnip',             commit = 'b310491' },
            { 'rafamadriz/friendly-snippets', commit = '572f566' },
        },
    },

    -- Bracket closing
    { 'windwp/nvim-autopairs', commit = '23320e7' },

    -- Commenting
    {
        'numToStr/Comment.nvim',
        commit = 'e30b7f2',
        config = function()
            require('Comment').setup()
        end,
    },

    -- Code folding
    {
        'kevinhwang91/nvim-ufo',
        commit = 'd31e2a9',
        dependencies = { { 'kevinhwang91/promise-async', commit = '119e896' } },
    },

    -- Status line
    {
        'nvim-lualine/lualine.nvim',
        commit = 'b8c2315',
        dependencies = { { 'nvim-tree/nvim-web-devicons', commit = '6e51ca1' } },
    },

    -- LSP progress in status line
    {
        'linrongbin16/lsp-progress.nvim',
        commit = 'f61cb7a',
        config = function()
            require('lsp-progress').setup()
        end,
    },
})
