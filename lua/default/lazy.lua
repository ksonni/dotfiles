local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- File finder
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
        },
    },

    -- Color scheme
    { "Mofiqul/dracula.nvim" },

    -- Syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
    },

    -- Tabless navigation
    {
        "theprimeagen/harpoon",
        branch = "harpoon2",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
        },
    },

    -- Git history
    { "tpope/vim-fugitive" },

    -- LSP
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },

    -- Completions
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            -- Autocompletion
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-cmdline" },
            { "hrsh7th/cmp-nvim-lua" },

            -- Snippets
            { "saadparwaiz1/cmp_luasnip" },
            { "L3MON4D3/LuaSnip" },
            { "rafamadriz/friendly-snippets" },
        },
    },

    -- Bracket closing
    { "windwp/nvim-autopairs" },

    -- Code folding
    {
        "kevinhwang91/nvim-ufo",
        dependencies = {
            { "kevinhwang91/promise-async" },
        },
    },

    -- Status line
    { "nvim-lualine/lualine.nvim" },

    -- LSP progress in status line
    {
        "linrongbin16/lsp-progress.nvim",
        config = function()
            require("lsp-progress").setup()
        end,
    },

    -- Markdown preview (browser-based, with Mermaid support)
    {
        "iamcco/markdown-preview.nvim",
        build = function(plugin)
            vim.opt.rtp:prepend(plugin.dir)
            vim.fn["mkdp#util#install"]()
        end,
        ft = { "markdown", "mermaid" },
    },
})
