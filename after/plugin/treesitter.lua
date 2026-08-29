local ok, treesitter = pcall(require, "nvim-treesitter")
if not ok then
    return
end

treesitter.setup()

local languages = { "vim", "query", "javascript", "typescript", "lua", "go", "c", "cpp", "python", "markdown", "markdown_inline" }

local parsers = vim.list_extend({ "vimdoc" }, languages)
local filetypes = vim.list_extend({ "help" }, languages)

treesitter.install(parsers)

vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})
