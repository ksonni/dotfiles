local ufo = require("ufo")

-- Enable vim folding in general
vim.o.foldcolumn = '0'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.keymap.set('n', 'z[', ufo.openAllFolds)
vim.keymap.set('n', 'z]', ufo.closeAllFolds)

-- nvim LSP as client
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}
local language_servers = require("lspconfig").util.available_servers()
for _, ls in ipairs(language_servers) do
    require('lspconfig')[ls].setup({
        capabilities = capabilities
        -- can add other fields for setting up lsp server in this table
    })
end

ufo.setup()
