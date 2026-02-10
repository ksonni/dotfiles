local ok, dracula = pcall(require, 'dracula')
if not ok then
    return
end

dracula.setup({
    transparent_bg = true,
})

vim.cmd.colorscheme('dracula')

-- Remove hardcoded telescope bg
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "none" })

-- Tweak the fugitive diff view
vim.cmd [[highlight DiffAdd ctermbg=237 guifg=NONE guibg=#2c452a]]

vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#323438", bg = "NONE" })
