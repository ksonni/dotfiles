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

-- Persist folds to disk
vim.opt.viewoptions = "folds"
local function is_normal_file(buf)
    local bt = vim.bo[buf].buftype
    return bt == "" and vim.bo[buf].modifiable
end
vim.api.nvim_create_autocmd("BufWinLeave", {
    callback = function(ev)
        if is_normal_file(ev.buf) then
            pcall(vim.cmd, "mkview")
        end
    end,
})
vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function(ev)
        if is_normal_file(ev.buf) then
            pcall(vim.cmd, "silent! loadview")
        end
    end,
})


ufo.setup()
