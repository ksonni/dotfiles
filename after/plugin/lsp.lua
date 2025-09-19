-- Diagnostics UI - icons + virtual text
local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
    virtual_text = true,
    severity_sort = true,
    float = { border = "rounded" },
})

-- Nicer borders for hover/signature
vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

-- Completion
local ok_cmp, cmp = pcall(require, "cmp")
if not ok_cmp then
    return
end

-- Snippets
local ok_luasnip, luasnip = pcall(require, "luasnip")
if ok_luasnip then
    require("luasnip.loaders.from_vscode").lazy_load()
end

-- Completion selection keymap
cmp.setup({
    snippet = {
        expand = function(args)
            if ok_luasnip then luasnip.lsp_expand(args.body) end
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-p>"]     = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-n>"]     = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-y>"]     = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        (ok_luasnip and { name = "luasnip" } or nil),
    }, {
        { name = "buffer" },
        { name = "path" },
    }),
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument = capabilities.textDocument or {}
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}

-- LSP remaps
local on_attach = function(_, bufnr)
    local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, remap = false, silent = true, desc = desc })
    end

    map("n", "gd", function() vim.lsp.buf.definition() end, "Goto definition")
    map("n", "K", function() vim.lsp.buf.hover() end, "Hover")
    map("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, "Workspace symbols")
    map("n", "<leader>d", function() vim.diagnostic.open_float() end, "Line diagnostics")
    map("n", "<leader>n", function() vim.diagnostic.goto_next() end, "Next diagnostic")
    map("n", "<leader>p", function() vim.diagnostic.goto_prev() end, "Prev diagnostic")
    map("n", "<leader>ca", function() vim.lsp.buf.code_action() end, "Code action")
    map("n", "<leader>o", function()
        vim.lsp.buf.code_action({
            context = { only = { "source.organizeImports" }, diagnostics = {} },
            apply = true,
        })
    end, "Organize imports")
    map("n", "<leader>r", function() vim.lsp.buf.rename() end, "Rename symbol")
    map("i", "<C-h>", function() vim.lsp.buf.signature_help() end, "Signature help")
end

-- Language servers

local ok_mason, mason = pcall(require, "mason")
local ok_mlsp, mlsp = pcall(require, "mason-lspconfig")

if not (ok_mason and ok_mlsp) then
    return
end

mason.setup()

local servers = {
    "lua_ls",
    "ts_ls",
    "gopls",
    "pbls",
}

mlsp.setup({
    ensure_installed = servers,
    automatic_installation = true,
})

for _, srv in ipairs(servers) do
    vim.lsp.config(srv, {
        on_attach = on_attach,
        capabilities = capabilities,
    })
end
