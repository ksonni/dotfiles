local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: pin plugin commits instead of tags because several upstream tags lag behind.
require("lazy").setup({
    -- File finder
    {
        "nvim-telescope/telescope.nvim",
        commit = "40aedd8",
        dependencies = {
            { "nvim-lua/plenary.nvim", commit = "74b06c6" },
        },
    },

    -- Color scheme
    {
        "Mofiqul/dracula.nvim",
        name = "dracula",
        commit = "ae752c1",
    },

    -- Syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        commit = "857651f",
        build = ":TSUpdate",
        lazy = false,
    },

    -- Tabless navigation
    {
        "theprimeagen/harpoon",
        branch = "harpoon2",
        commit = "87b1a35",
        dependencies = {
            { "nvim-lua/plenary.nvim", commit = "74b06c6" },
        },
    },

    -- Git history
    { "tpope/vim-fugitive",                commit = "3b753cf" },

    -- LSP
    { "neovim/nvim-lspconfig",             commit = "684cb45" },
    { "williamboman/mason.nvim",           commit = "2a6940a" },
    { "williamboman/mason-lspconfig.nvim", commit = "40276c4" },

    -- Completions
    {
        "hrsh7th/nvim-cmp",
        commit = "2ffe79f",
        dependencies = {
            -- Autocompletion
            { "hrsh7th/cmp-nvim-lsp",         commit = "cbc7b02" },
            { "hrsh7th/cmp-buffer",           commit = "b74fab3" },
            { "hrsh7th/cmp-path",             commit = "c642487" },
            { "hrsh7th/cmp-cmdline",          commit = "d126061" },
            { "hrsh7th/cmp-nvim-lua",         commit = "e3a22cb" },

            -- Snippets
            { "saadparwaiz1/cmp_luasnip",     commit = "98d9cb5" },
            { "L3MON4D3/LuaSnip",             commit = "0abc8f3" },
            { "rafamadriz/friendly-snippets", commit = "6cd7280" },
        },
    },

    -- Bracket closing
    { "windwp/nvim-autopairs", commit = "430522f" },

    -- Code folding
    {
        "kevinhwang91/nvim-ufo",
        commit = "ab3eb12",
        dependencies = {
            { "kevinhwang91/promise-async", commit = "119e896" },
        },
    },

    -- Status line
    {
        "nvim-lualine/lualine.nvim",
        commit = "221ce6b",
        dependencies = {
            { "nvim-tree/nvim-web-devicons", commit = "2ae6958" },
        },
    },

    -- LSP progress in status line
    {
        "linrongbin16/lsp-progress.nvim",
        commit = "f6d5af1",
        config = function()
            require("lsp-progress").setup()
        end,
    },

    -- Markdown preview (browser-based, with Mermaid support)
    {
        "iamcco/markdown-preview.nvim",
        commit = "a923f5fc",
        build = function(plugin)
            vim.opt.rtp:prepend(plugin.dir)
            vim.fn["mkdp#util#install"]()
        end,
        ft = { "markdown", "mermaid" },
    },
})
