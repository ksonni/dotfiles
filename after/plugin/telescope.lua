local ok, telescope = pcall(require, 'telescope')
if not ok then
    return
end
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

-- Use an env variables to ignore certain directories in the project
-- without cluttering the repo with a specific .ignore file.
-- in your telescope setup file
local ignore_env = vim.env.VIMIGNORE or ""
local ignore_patterns = {}
for pat in string.gmatch(ignore_env, '([^,]+)') do
    pat = pat:gsub("^%s+", ""):gsub("%s+$", "") -- trim spaces
    table.insert(ignore_patterns, pat)
end

telescope.setup({
    defaults = {
        layout_strategy = 'vertical',
        file_ignore_patterns = ignore_patterns,
    },
})

-- Find and replace - use telescope to search, Ctr+Q & then run `:Replace s/old/new/g`
vim.api.nvim_create_user_command("Replace", function(opts)
    if vim.tbl_isempty(vim.fn.getqflist()) then
        vim.notify("Quickfix list is empty", vim.log.levels.ERROR)
        return
    end
    vim.cmd("cfdo " .. opts.args .. " | update")
end, { nargs = 1 })
