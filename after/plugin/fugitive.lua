vim.keymap.set("n", "<leader>gs", "<cmd>horizontal Git<CR>")
vim.keymap.set("n", "<leader>vd", "<cmd>Gvdiffsplit<CR>")

vim.api.nvim_create_user_command("GitTrace", function(opts)
    local file = vim.fn.expand("%")
    if file == "" then
        vim.notify("GitTrace: no file in current buffer", vim.log.levels.WARN)
        return
    end
    local escaped_file = vim.fn.fnameescape(file)
    if opts.range > 0 then
        local no_patch = opts.bang and "" or " --no-patch"
        vim.cmd(("Git log%s -L %d,%d:%s"):format(no_patch, opts.line1, opts.line2, escaped_file))
        return
    end
    local patch = opts.bang and " --patch" or ""
    vim.cmd("Git log --follow" .. patch .. " -- " .. escaped_file)
end, {
    bang = true,
    range = true,
    desc = "Trace git history for the current file or selected lines; use ! to include file diffs",
})

-- LSPs don't work on fugitive buffers and some of them can raise annying errors while
-- viewing the change. So mark them as non-file buffers to prevent LSPs from attaching.
vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        if vim.bo[args.buf].buftype == "" and vim.startswith(vim.api.nvim_buf_get_name(args.buf), "fugitive:///") then
            vim.bo[args.buf].buftype = "nowrite"
        end
    end,
})
