vim.g.mapleader = " "

-- Just use :Ex dammit!
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Like Ex but takes you to the Git root of the project
vim.api.nvim_create_user_command("Er", function()
    vim.cmd("clearjumps")

    local r = vim.system({ "git", "rev-parse", "--show-toplevel" }, { text = true }):wait()
    if r.code ~= 0 then return end

    local root = (r.stdout or ""):gsub("%s+$", "")
    if root == "" then return end

    -- Force global cwd back to repo root (beats fugitive's lcd)
    vim.cmd("cd " .. vim.fn.fnameescape(root))

    -- Open netrw explicitly at root (avoids its internal cwd cache)
    vim.cmd("Explore " .. vim.fn.fnameescape(root))
end, { desc = "Clear jumps and return to git root" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set('n', '<C-w><Right>', '<cmd>vertical resize +10<CR>')
vim.keymap.set('n', '<C-w><Left>', '<cmd>vertical resize -10<CR>')
vim.keymap.set('n', '<C-w><Up>', '<cmd>resize +5<CR>')
vim.keymap.set('n', '<C-w><Down>', '<cmd>resize -5<CR>')

-- Copy filename for copilot
vim.keymap.set("n", "<leader>ay", function()
    vim.fn.setreg("+", "@" .. vim.fn.expand("%:."))
end, { desc = "Copy relative file path" })

-- Yank relative file name for AI agents
vim.keymap.set("n", "<leader>af", function()
    vim.fn.setreg("+", "@" .. vim.fn.expand("%:."))
end, { desc = "Yank @file (relative path)" })

-- Yank relative file name with line number
vim.keymap.set("n", "<leader>al", function()
    local path = vim.fn.expand("%:.")
    local line = vim.fn.line(".")
    vim.fn.setreg("+", "@" .. path .. ":" .. line)
end, { desc = "Yank @file:line" })

-- Yank relative file name with line range and exit viual mode
vim.keymap.set("v", "al", function()
    local path = vim.fn.expand("%:.")

    local anchor = vim.fn.getpos("v") -- start of selection
    local cursor = vim.fn.getpos(".") -- end of selection (current cursor)

    local a_line, a_col = anchor[2], anchor[3]
    local c_line, c_col = cursor[2], cursor[3]

    local start_line, end_line = a_line, c_line
    if start_line > end_line then start_line, end_line = end_line, start_line end

    vim.fn.setreg("+", ("@%s:%d-%d"):format(path, start_line, end_line))

    -- exit visual mode
    vim.cmd("normal! \27")

    -- mimic `y` cursor behavior:
    if (a_line < c_line) or (a_line == c_line and a_col <= c_col) then
        vim.fn.setpos(".", anchor)
    end
end, { desc = "Yank @file:start-end" })
