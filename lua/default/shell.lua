-- Helper to open tmux split in current file dir, optionally running a command
local function tmux_split_in_file_dir(cmd, prog)
    if not vim.env.TMUX or vim.env.TMUX == "" then
        vim.notify(":" .. prog .. ": not running inside tmux", vim.log.levels.ERROR)
        return
    end

    -- Current file's parent dir; fallback to current working dir
    local dir = vim.fn.expand("%:p:h")
    if dir == "" then
        dir = vim.fn.getcwd()
    end

    local base = { "tmux", "split-window", "-v", "-l", "30%", "-c", dir }

    -- Send command to terminal if exists
    if cmd and cmd ~= "" then
        local shell = vim.env.SHELL
        if not shell or shell == "" then shell = "bash" end

        local wrapped = shell .. " -ic " .. vim.fn.shellescape(cmd .. "; exec " .. shell)
        table.insert(base, wrapped)
    end

    vim.fn.system(base)
end

-- :Sh [cmd...] opens a split terminal and runns the command in current file dir
vim.api.nvim_create_user_command("Sh", function(opts)
    tmux_split_in_file_dir(opts.args, "Sh")
end, { nargs = "*", complete = "shellcmd" })

-- :Test runs $VIMTESTCMD similar to Sh
vim.api.nvim_create_user_command("Test", function()
    local test_command = vim.env.VIMTESTCMD or ""
    if test_command == "" then
        vim.notify(":Test: $VIMTESTCMD is not set", vim.log.levels.ERROR)
        return
    end
    tmux_split_in_file_dir(test_command, "Test")
end, {})
