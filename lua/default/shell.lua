-- Helper to open tmux split in current file dir, optionally running a command
local function tmux_split_in_file_dir(cmd, prog)
    if not vim.env.TMUX or vim.env.TMUX == "" then
        vim.notify(":" .. prog .. ": not running inside tmux", vim.log.levels.ERROR)
        return
    end

    -- Current file's parent dir; fallback to current working dir
    local dir = vim.fn.expand("%:p:h")
    if dir == "" then dir = vim.fn.getcwd() end

    local shell = vim.env.SHELL
    if not shell or shell == "" then shell = "bash" end

    -- Find an existing pane titled "integrated" in the current window
    local panes = vim.fn.systemlist({ "tmux", "list-panes", "-F", "#{pane_id} #{pane_title}" })
    local target
    for _, line in ipairs(panes) do
        local pane_id, title = line:match("^(%S+)%s+(.*)$")
        if pane_id and title == "integrated" then
            target = pane_id
            break
        end
    end

    if target then
        -- Reuse existing integrated pane
        vim.fn.system({ "tmux", "select-pane", "-t", target })
        vim.fn.system({ "tmux", "send-keys", "-t", target, "cd " .. vim.fn.shellescape(dir), "Enter" })

        if cmd and cmd ~= "" then
            vim.fn.system({ "tmux", "send-keys", "-t", target, cmd, "Enter" })
        end

        return
    end

    -- Create a new split and title it "integrated"
    local base = { "tmux", "split-window", "-v", "-l", "30%", "-c", dir }

    -- Raw terminal if no cmd; otherwise run cmd then stay interactive
    if cmd and cmd ~= "" then
        local wrapped = shell .. " -ic " .. vim.fn.shellescape(cmd .. "; exec " .. shell)
        table.insert(base, wrapped)
    else
        table.insert(base, shell)
    end

    vim.fn.system(base)
    -- Title the newly-created pane (it becomes active after split-window)
    vim.fn.system({ "tmux", "select-pane", "-T", "integrated" })
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
