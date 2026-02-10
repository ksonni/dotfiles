local wezterm = require 'wezterm'
local mux = wezterm.mux

wezterm.on('gui-startup', function(window)
    local _, pane, window = mux.spawn_window(cmd or {})
    local gui_window = window:gui_window();
    gui_window:perform_action(wezterm.action.ToggleFullScreen, pane)
end)

local colors = {
    "#1E1F22", -- Grey - graphite dark (default)
    "#222B26", -- Green - moss slate
    "#1F2430", -- Blue - night ocean
    "#2B1F1F", -- Red - dried blood
    "#2A211B", -- Orange - burnt umber
    "#2A271E", -- Yellow - muted mustard charcoal
    "#2A1F2E", -- Pink - muted plum
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

    -- Colors
    colors = {
        background = colors[math.random(#colors)],
        cursor_bg = '#FFFFFF',
        cursor_border = '#FFFFFF',
        foreground = "#FFFFFF"
    },

    -- Window
    window_close_confirmation = 'NeverPrompt',
    window_background_opacity = 0.96,
    hide_tab_bar_if_only_one_tab = true,
}
