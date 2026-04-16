-- Markdown checkbox toggling in normal and visual mode.
--
-- toggle()        → current line
-- toggle_visual() → all lines in current visual selection
--
-- Per-line logic:
--   - [x] text   →  - [ ] text   (uncheck)
--   - [ ] text   →  - [x] text   (check)
--   - text       →  - [ ] text   (promote bullet to checkbox)
--   (empty)      →  - [ ]        (insert mode, ready to type)
--   plain text   →  - [ ] plain text (wrap as checkbox)
-- Indentation is always preserved. Once a checkbox, it only ever toggles.

local M = {}

local function toggle_line(line)
    local indent, rest = line:match("^(%s*)(.*)")
    if rest:match("^%- %[x%] ") then
        return indent .. rest:gsub("^%- %[x%] ", "- [ ] ", 1)
    elseif rest:match("^%- %[ %] ") then
        return indent .. rest:gsub("^%- %[ %] ", "- [x] ", 1)
    elseif rest:match("^%- ") then
        return indent .. rest:gsub("^%- ", "- [ ] ", 1)
    else
        return indent .. "- [ ] " .. rest
    end
end

function M.toggle()
    local lnum = vim.fn.line(".")
    local line = vim.fn.getline(lnum)
    if line:match("^%s*$") then
        local indent = line:match("^(%s*)") or ""
        vim.fn.setline(lnum, indent .. "- [ ] ")
        vim.cmd("startinsert!")
    else
        vim.fn.setline(lnum, toggle_line(line))
        vim.cmd("write")
    end
end

function M.toggle_visual()
    local s = vim.fn.line("v")
    local e = vim.fn.line(".")
    if s > e then s, e = e, s end
    for lnum = s, e do
        vim.fn.setline(lnum, toggle_line(vim.fn.getline(lnum)))
    end
    vim.cmd("write")
end

return M
