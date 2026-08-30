-- NOTE: when adding new languages, also update after/plugin/treesitter.lua.
local servers = {
    lua_ls = {
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                },
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    },
    ts_ls = {},   -- Typescript
    gopls = {},   -- Golang
    pbls = {},    -- Protobuf
    pyright = {}, -- Python LSP
    ruff = {},    -- Python linting/formatting
    clangd = {},  -- C development
}
local tools = {
    mypy = {}, -- Python type checking
}

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
    function(err, result, ctx, config)
        return vim.lsp.handlers.hover(err, result, ctx, vim.tbl_extend("force", config or {}, { border = "rounded" }))
    end
vim.lsp.handlers["textDocument/signatureHelp"] =
    function(err, result, ctx, config)
        return vim.lsp.handlers.signature_help(err, result, ctx,
            vim.tbl_extend("force", config or {}, { border = "rounded" }))
    end

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
        { name = "nvim_lua" },
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
local function goto_diagnostic(count)
    local cur = vim.api.nvim_win_get_cursor(0)

    vim.diagnostic.jump({ count = count, severity = vim.diagnostic.severity.ERROR })

    if vim.deep_equal(cur, vim.api.nvim_win_get_cursor(0)) then
        vim.diagnostic.jump({ count = count })
    end
end

-- Collects all known errors to a quickfix list
local function workspace_errors()
    local diags = vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.ERROR })
    table.sort(diags, function(a, b)
        if a.severity ~= b.severity then return a.severity < b.severity end
        if a.bufnr ~= b.bufnr then return (a.bufnr or 0) < (b.bufnr or 0) end
        return a.lnum < b.lnum
    end)
    local items = vim.diagnostic.toqflist(diags)
    vim.fn.setqflist({}, "r", { title = "Workspace Diagnostics", items = items })
    if #items > 0 then
        vim.cmd("copen")
    else
        vim.notify("No errors found", vim.log.levels.INFO)
    end
end

vim.keymap.set("n", "<leader>we", workspace_errors, { desc = "Workspace errors to a quickfix list" })

-- LSP remaps
local on_attach = function(client, bufnr)
    -- Token highlighting with the current theme looks ugly, so disabling for now
    client.server_capabilities.semanticTokensProvider = nil

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
    map("n", "<leader>n", function() goto_diagnostic(1) end, "Next diagnostic")
    map("n", "<leader>p", function() goto_diagnostic(-1) end, "Prev diagnostic")
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
local ok_mti, mti = pcall(require, "mason-tool-installer")

if not (ok_mason and ok_mlsp and ok_mti) then
    return
end

mason.setup()

for srv, config in pairs(servers) do
    vim.lsp.config(srv, vim.tbl_deep_extend("force", {
        on_attach = on_attach,
        capabilities = capabilities,
    }, config))
end
mlsp.setup({
    ensure_installed = vim.tbl_keys(servers),
    automatic_enable = vim.tbl_keys(servers),
})
mti.setup({
    ensure_installed = vim.tbl_keys(tools),
})
