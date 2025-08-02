vim.keymap.set("n", "<leader>we", function()
    local indent = vim.fn.indent(".")
    local pad = string.rep(" ", indent)
    local lines = {
        pad .. "if err != nil {",
        pad .. "    return err",
        pad .. "}",
    }
    vim.api.nvim_put(lines, "l", true, true)
end, { desc = "Insert Go error check" })

vim.keymap.set("n", "<leader>wn", function()
    local indent = vim.fn.indent(".")
    local pad = string.rep(" ", indent)
    local lines = {
        pad .. "if err != nil {",
        pad .. "    return nil, err",
        pad .. "}",
    }
    vim.api.nvim_put(lines, "l", true, true)
end, { desc = "Insert Go error check" })
