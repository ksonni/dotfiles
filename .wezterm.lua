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

local colors = {
    "#2A1F2E", -- Pink - muted plum (default)
    "#2B1F1F", -- Red - dried blood
    "#222B26", -- Green - moss slate
    "#1F2430", -- Blue - night ocean
    "#2A271E", -- Yellow - muted mustard charcoal
    "#1E1F22", -- Grey - graphite dark
}

local prefs_file = wezterm.home_dir .. "/.wezterm-prefs.json"

local function load_prefs()
    local file = io.open(prefs_file, "r")
    if not file then
        return {}
    end
    local content = file:read("*a")
    file:close()
    local ok, prefs = pcall(wezterm.json_parse, content)
    if not ok or type(prefs) ~= "table" then
        return {}
    end
    return prefs
end

local function save_prefs(prefs)
    local file = io.open(prefs_file, "w")
    if not file then
        wezterm.log_error("Unable to write custom WezTerm prefs: " .. prefs_file)
        return
    end
    file:write(wezterm.json_encode(prefs))
    file:close()
end

local function load_background_index()
    local prefs = load_prefs()
    local index = tonumber(prefs.background_index)
    if not index or index < 1 or index > #colors then
        return 1
    end
    return math.floor(index)
end

local font_size = 9
if wezterm.target_triple:find("apple") then
    font_size = 12
end

wezterm.on('toggle-opacity', function(window, _)
    local overrides = window:get_config_overrides() or {}
    if overrides.window_background_opacity then
        overrides.window_background_opacity = nil
    else
        overrides.window_background_opacity = 0.4
    end
    window:set_config_overrides(overrides)
end)

wezterm.on('rotate-background', function(window, _)
    local next_index = (load_background_index() % #colors) + 1
    local prefs = load_prefs()
    prefs.background_index = next_index
    save_prefs(prefs)
    wezterm.reload_configuration()
end)

local background_index = load_background_index()

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
    warn_about_missing_glyphs = false,

    -- Colors
    colors = {
        background = colors[background_index],
        cursor_bg = '#FFFFFF',
        cursor_border = '#FFFFFF',
        foreground = "#FFFFFF"
    },

    -- Window
    window_close_confirmation = 'NeverPrompt',
    window_background_opacity = 0.96,
    hide_tab_bar_if_only_one_tab = true,
    window_decorations = "RESIZE",
    native_macos_fullscreen_mode = true,

    keys = {
        {
            key = 'o',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.EmitEvent 'toggle-opacity',
        },
        {
            key = 'C',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.EmitEvent 'rotate-background',
        },
    },
}
