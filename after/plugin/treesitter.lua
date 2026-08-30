local languages = {
    "vim",
    "query",
    "javascript",
    "typescript",
    "lua",
    "go",
    "c",
    "cpp",
    "python",
    "markdown",
    "markdown_inline",
}

local parsers = vim.list_extend({ "vimdoc", "starlark" }, languages)
local filetypes = vim.list_extend({ "help", "bzl" }, languages)

local ok, treesitter = pcall(require, "nvim-treesitter")
if not ok then
    return
end

treesitter.setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
})
vim.opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/runtime")

treesitter.install(parsers)

vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})
