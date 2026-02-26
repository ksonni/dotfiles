-- TLDR:
-- :Review - convert the current window to code review against master merge-base,
-- includes uncommited changes as well.
-- <leader>gf on the hunk takes you to the file in a right split
-- :Er - back to git root
-- ]f and [f to do next file & previous file
-- ]cc and [c to do next change & previous change

local function open_review_panel(branch, cmd_fn)
    local function merge_base(ref)
        local r = vim.system({ "git", "merge-base", ref, "HEAD" }, { text = true }):wait()
        if r.code == 0 then
            return (r.stdout or ""):gsub("%s+$", "")
        end
    end

    local mb = ""
    if branch ~= "" then
        mb = merge_base(branch)
    else
        mb = merge_base("master") or merge_base("main")
    end

    local prev_win = vim.api.nvim_get_current_win()
    local prev_tab = vim.api.nvim_get_current_tabpage()

    vim.cmd(cmd_fn(mb))

    -- If Fugitive opened a new window, close the old one
    if vim.api.nvim_get_current_tabpage() == prev_tab then
        local cur_win = vim.api.nvim_get_current_win()
        if cur_win ~= prev_win and vim.api.nvim_win_is_valid(prev_win) then
            vim.api.nvim_win_close(prev_win, true)
        end
    end
end

-- Command to compare diffs against master merge-base to review code. Occupies the whole window closing the base pane.
vim.api.nvim_create_user_command("Review", function(opts)
    open_review_panel(opts.args, function(base)
        return "Git diff " .. base
    end)
end, { nargs = "*", desc = "Code review diffs against master/main or custom branch" })

-- Command to compare commits against merge-base to review code. Occupies the whole window closing the base pane.
vim.api.nvim_create_user_command("Log", function(opts)
    open_review_panel(opts.args, function(base)
        return "Git log " .. base .. "..HEAD"
    end)
end, { nargs = "*", desc = "Code review commits vs master/main or custom branch" })

-- Opens the window on the right if it exists, if not makes a new one
local function open_right_or_vsplit(cmd)
    local cur = vim.api.nvim_get_current_win()
    local cur_pos = vim.api.nvim_win_get_position(cur)

    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if win ~= cur then
            local pos = vim.api.nvim_win_get_position(win)
            if pos[1] == cur_pos[1] and pos[2] > cur_pos[2] then
                vim.api.nvim_set_current_win(win)
                vim.cmd(cmd)
                return
            end
        end
    end
    vim.cmd("rightbelow " .. cmd:gsub("^edit", "vsplit", 1))
    vim.cmd("vertical resize " .. math.floor(vim.o.columns * 0.6))
end

-- Some sorcery to jump from a fugitive diff to the actual file
vim.keymap.set("n", "<leader>gf", function()
    local buf = vim.api.nvim_get_current_buf()
    local cur = vim.api.nvim_win_get_cursor(0)[1]

    local function getline(i)
        return vim.api.nvim_buf_get_lines(buf, i - 1, i, false)[1]
    end

    local path, hunk_line, new_start

    -- search upwards for hunk header and diff header
    for i = cur, 1, -1 do
        local l = getline(i)
        if not l then break end

        if not hunk_line then
            local ns = l:match("^@@ %-%d+,?%d* %+(%d+),?%d* @@")
            if ns then
                hunk_line = i
                new_start = tonumber(ns)
            end
        end

        if not path then
            path = l:match("^diff %-%-git a/.- b/(.+)$")
        end

        if path and hunk_line then break end
    end

    if not path then return end
    if not hunk_line then
        vim.cmd("edit " .. vim.fn.fnameescape(path))
        return
    end

    -- compute target line in the "new" file (+ side)
    local new_line = new_start

    -- advance through hunk lines up to (but not including) cursor line
    for i = hunk_line + 1, cur - 1 do
        local l = getline(i) or ""
        local c = l:sub(1, 1)
        if c == " " or c == "+" then
            new_line = new_line + 1
        end
    end

    -- decide target for the cursor line itself
    local cl = getline(cur) or ""
    local cc = cl:sub(1, 1)
    local target = new_line
    if cc == " " or cc == "+" then
        target = new_line
    elseif cc == "-" then
        target = new_line -- deleted line: best-effort landing spot
    elseif cl:match("^@@") then
        target = new_start
    end

    open_right_or_vsplit(("edit +%d %s"):format(math.max(1, target), vim.fn.fnameescape(path)))
end, { silent = true })

vim.keymap.set("n", "]f", function()
    vim.fn.search("^diff --git", "W")
end, { desc = "Next file in diff" })

vim.keymap.set("n", "[f", function()
    vim.fn.search("^diff --git", "bW")
end, { desc = "Previous file in diff" })
