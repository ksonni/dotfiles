local function bot_file_ref(line1, line2)
    local path = vim.fn.expand("%:.")
    if line1 and line2 then
        if line1 == line2 then
            return ("@%s:%d"):format(path, line1)
        end
        return ("@%s:%d-%d"):format(path, line1, line2)
    end
    return "@" .. path
end

-- Yank relative file name for AI agents
vim.keymap.set("n", "<leader>af", function()
    vim.fn.setreg("+", bot_file_ref())
end, { desc = "Yank @file (relative path)" })

-- Yank relative file name with line number
vim.keymap.set("n", "<leader>al", function()
    local line = vim.fn.line(".")
    vim.fn.setreg("+", bot_file_ref(line, line))
end, { desc = "Yank @file:line" })

-- Yank relative file name with line range and exit visual mode
vim.keymap.set("v", "<leader>al", function()
    local anchor = vim.fn.getpos("v")
    local cursor = vim.fn.getpos(".")

    local a_line, a_col = anchor[2], anchor[3]
    local c_line, c_col = cursor[2], cursor[3]

    local start_line, end_line = a_line, c_line
    if start_line > end_line then
        start_line, end_line = end_line, start_line
    end

    vim.fn.setreg("+", bot_file_ref(start_line, end_line))

    vim.cmd("normal! \27")

    -- mimic `y` cursor behavior
    if (a_line < c_line) or (a_line == c_line and a_col <= c_col) then
        vim.fn.setpos(".", anchor)
    end
end, { desc = "Yank @file:start-end" })

-- Directly send commands to copilot with file refs open
vim.api.nvim_create_user_command("Bot", function(opts)
    local ref
    if opts.range > 0 then
        ref = bot_file_ref(opts.line1, opts.line2)
    else
        ref = bot_file_ref()
    end

    local msg = ref
    if opts.args ~= "" then
        msg = msg .. " " .. opts.args
    end

    local pane_id = vim.trim(vim.fn.system(
        [[tmux list-panes -a -F '#{pane_id} #{@role}' | awk '$2=="assist"{print $1; exit}']]
    ))
    if pane_id == "" then
        vim.notify('No tmux pane titled "assist" found', vim.log.levels.ERROR)
        return
    end

    vim.fn.system({
        "tmux", "select-pane", "-t", pane_id, ";",
        "run-shell", "sleep 0.2", ";", -- hack to make copilot UI behave
        "send-keys", "-l", msg, ";",
        "run-shell", "sleep 0.2", ";", -- hack to make copilot UI behave
        "send-keys", "C-m",
    })
end, {
    nargs = "+",
    range = true,
    desc = "Send @file ref and prompt to tmux pane titled assist",
})
