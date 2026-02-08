-- Diagnostics UI - icons + virtual text
vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "E",
            [vim.diagnostic.severity.WARN]  = "W",
            [vim.diagnostic.severity.HINT]  = "H",
            [vim.diagnostic.severity.INFO]  = "I",
        },
    },
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

local ok_telescope, telescope = pcall(require, "telescope.builtin")

-- Go to next/previous diagnostic, prioritizing errors
local function goto_diagnostic(goto_fn)
    local cur = vim.api.nvim_win_get_cursor(0)

    goto_fn({ severity = vim.diagnostic.severity.ERROR })

    if vim.deep_equal(cur, vim.api.nvim_win_get_cursor(0)) then
        goto_fn()
    end
end

-- LSP remaps
local on_attach = function(_, bufnr)
    local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, remap = false, silent = true, desc = desc })
    end

    if ok_telescope then
        map("n", "gd", function() telescope.lsp_definitions() end)
        map("n", "gr", function() telescope.lsp_references() end)
        map("n", "gi", function() telescope.lsp_implementations() end)
    end

    map("n", "K", function() vim.lsp.buf.hover() end, "Hover")
    map("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, "Workspace symbols")
    map("n", "<leader>d", function() vim.diagnostic.open_float() end, "Line diagnostics")
    map("n", "<leader>n", function() goto_diagnostic(vim.diagnostic.goto_next) end, "Next diagnostic")
    map("n", "<leader>p", function() goto_diagnostic(vim.diagnostic.goto_prev) end, "Prev diagnostic")
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
local ok_mregistry, mregistry = pcall(require, "mason-registry")


if not (ok_mason and ok_mlsp and ok_mregistry) then
    return
end

mason.setup()

local servers = {
    "lua_ls",
    "ts_ls",
    "gopls",
    "pbls",    -- Protobuf
    "pyright", -- Python LSP
    "ruff",    -- Python linting/formatting
}

local other_packages = {
    "mypy", -- Python type checking
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

for _, name in ipairs(other_packages) do
    local pkg = mregistry.get_package(name)
    if not pkg:is_installed() then
        pkg:install()
    end
end
