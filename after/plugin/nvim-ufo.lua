local ok, ufo = pcall(require, "ufo")
if not ok then
    return
end

-- Enable vim folding in general
vim.o.foldcolumn = '0'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.keymap.set('n', 'z[', ufo.openAllFolds)
vim.keymap.set('n', 'z]', ufo.closeAllFolds)

ufo.setup()
