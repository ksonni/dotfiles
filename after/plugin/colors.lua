local ok, dracula = pcall(require, 'dracula')
if not ok then
    return
end

dracula.setup({
    colors = {
        bg = '#1E1F22',
    },
    -- transparent_bg = true,
})

vim.cmd.colorscheme('dracula')

-- Tweak the fugitive diff view
vim.cmd [[highlight DiffAdd ctermbg=237 guifg=NONE guibg=#2c452a]]

vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#323438", bg = "NONE" })
