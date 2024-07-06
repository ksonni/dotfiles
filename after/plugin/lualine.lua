require('lualine').setup {
    options = { theme = 'dracula' },
    sections = {
        lualine_x = {
            function()
                return require('lsp-progress').progress()
            end,
        },
    },
}

-- listen lsp-progress event and refresh lualine
vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
    group = 'lualine_augroup',
    pattern = 'LspProgressStatusUpdated',
    callback = require('lualine').refresh
})

