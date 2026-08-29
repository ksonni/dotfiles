local ok, harpoon, harpoon_extensions = pcall(function()
    return require("harpoon"), require("harpoon.extensions")
end)
if not ok then
    return
end

harpoon:setup({
    settings = {
        save_on_toggle = true,
    },
})
harpoon:extend(harpoon_extensions.builtins.highlight_current_file())

local function toggle_harpoon_menu()
    harpoon.ui:toggle_quick_menu(harpoon:list(), {
        ui_width_ratio = 0.5,
        title = "",
    })
    if harpoon.ui.win_id and vim.api.nvim_win_is_valid(harpoon.ui.win_id) then
        vim.api.nvim_set_option_value("winhighlight",
            "Normal:HarpoonNormal,NormalFloat:HarpoonNormal,FloatBorder:HarpoonBorder", {
                win = harpoon.ui.win_id,
            })
    end
end

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>e", toggle_harpoon_menu)
vim.keymap.set("n", "<leader>h", function() harpoon:list():prev() end)
vim.keymap.set("n", "<leader>l", function() harpoon:list():next() end)

vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)
