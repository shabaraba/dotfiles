local wezterm = require'wezterm';

local BinaryFormat = package.cpath:match("%p[\\|/]?%p(%a+)")
if BinaryFormat == "dll" then
    function os.name()
        return "Windows"
    end
elseif BinaryFormat == "so" then
    function os.name()
        return "Linux"
    end
elseif BinaryFormat == "dylib" then
    function os.name()
        return "MacOS"
    end
end
BinaryFormat = nil

local default_prog_ = nil;
local decorations_ = 'TITLE | RESIZE';

if BinaryFormat == 'Windows' then
    default_prog_ = {"wsl.exe", "--exec", "/bin/zsh", "-l"};
    decorations_ = 'RESIZE';
end

return {
    initial_rows = 30,
    initial_cols = 150,
    window_decorations = decorations_;
    window_background_image_hsb = {
        -- Darken the background image by reducing it to 1/3rd
        brightness = 0.3,

        -- You can adjust the hue by scaling its value.
        -- a multiplier of 1.0 leaves the value unchanged.
        hue = 1.0,

        -- You can adjust the saturation also.
        saturation = 1.0,
    },
    window_background_opacity = 0.8,
    font_dirs = {"fonts"},
    -- font = wezterm.font("Firge Console", {weight="Regular", stretch="Normal", italic=false}),
    font_size = 14,
    color_scheme = "Gruvbox Dark",
    harfbuzz_features = {"calt=1", "clig=1", "liga=1"},
    exit_behavior = "Close",

    keys = {
        {key = "w", mods = "ALT", action = wezterm.action{CloseCurrentPane={confirm=true}}},
        {key = 'h', mods = 'CMD', action = wezterm.action.Hide},
    },
    default_prog = default_prog_,
}

