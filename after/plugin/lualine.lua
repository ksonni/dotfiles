local ok, lualine = pcall(require, "lualine")
if not ok then
    return
end

lualine.setup {
    options = { theme = 'dracula' },
    sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
            {
                'filename',
                file_status = true, -- readonly/modified etc.
                path = 1,           -- 0 = name, 1 = relative path, 2 = full
            },
        },
        lualine_x = {
            function()
                local msg = require('lsp-progress').progress()
                if msg ~= " LSP" then
                    return msg
                end
                return ""
            end,
        },
        lualine_y = {},
        lualine_z = {},
    },
}

-- listen lsp-progress event and refresh lualine
vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
    group = 'lualine_augroup',
    pattern = 'LspProgressStatusUpdated',
    callback = require('lualine').refresh
})
