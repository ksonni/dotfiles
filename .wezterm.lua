local wezterm = require 'wezterm'
local mux = wezterm.mux

wezterm.on('gui-startup', function(window)
    local _, _, window = mux.spawn_window(cmd or {})
    local gui_window = window:gui_window();
    if wezterm.target_triple:find('apple%-darwin') then
        gui_window:toggle_fullscreen()
    else
        gui_window:maximize()
    end
end)

wezterm.GLOBAL.session = wezterm.GLOBAL.session or 0

wezterm.on("window-config-reloaded", function(_, _)
    wezterm.GLOBAL.session = wezterm.GLOBAL.session + 1
end)

local colors = {
    "#2A1F2E", -- Pink - muted plum (default)
    "#2B1F1F", -- Red - dried blood
    "#222B26", -- Green - moss slate
    "#1F2430", -- Blue - night ocean
    "#2A271E", -- Yellow - muted mustard charcoal
    "#1E1F22", -- Grey - graphite dark
}

local font_size = 10.0
if wezterm.target_triple:find("apple") then
    font_size = 13.0
end

return {
    -- Font
    font = wezterm.font('JetBrainsMono Nerd Font Mono', {
        weight = 'Bold',
        stretch = 'Normal',
        style = 'Normal',
    }),
    font_size = font_size,
    -- Disable font ligatures like !=
    harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },

    -- Colors
    colors = {
        background = colors[(wezterm.GLOBAL.session % #colors) + 1],
        cursor_bg = '#FFFFFF',
        cursor_border = '#FFFFFF',
        foreground = "#FFFFFF"
    },

    -- Window
    window_close_confirmation = 'NeverPrompt',
    window_background_opacity = 0.96,
    hide_tab_bar_if_only_one_tab = true,
    window_decorations = "RESIZE",
}
