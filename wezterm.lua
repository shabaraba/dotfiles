local wezterm = require'wezterm';
return {
    window_decorations = "RESIZE",
    window_background_opacity = 0.8,
    font_dirs = {"fonts"},
    font = wezterm.font("HackGenNerd Console", {weight="Regular", stretch="Normal", italic=false}),
    color_scheme = "Gruvbox Dark",
    harfbuzz_features = {"calt=1", "clig=1", "liga=1"},
    default_prog = {"wsl.exe", "--exec", "/bin/zsh", "-l"},
    exit_behavior = "Close",

    keys = {
        {key = "w", mods = "ALT", action = wezterm.action{CloseCurrentPane={confirm=true}}}
    },
}

