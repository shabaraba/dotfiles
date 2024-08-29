local wezterm = require'wezterm';
local config = wezterm.config_builder();
local act = require "wezterm".action;

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

wezterm.on('update-status', function(window, pane)
  local workspace = window:active_workspace()
  window:set_left_status(wezterm.format({
    {Text = ' ' .. workspace .. ' '}
  }))
end)

config = {
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
    font_dirs = {"fonts"},
    -- font = wezterm.font("Firge Console", {weight="Regular", stretch="Normal", italic=false}),
    font_size = 14,
    color_scheme = "Gruvbox Dark",
    colors = {
      background = '#1b1f21',
    },
    window_background_opacity = 0.8,
    macos_window_background_blur = 30,
    harfbuzz_features = {"calt=1", "clig=1", "liga=1"},
    exit_behavior = "Close",

    leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 },
    keys = {
        {key = "w", mods = "ALT", action = wezterm.action{CloseCurrentPane={confirm=true}}},
        {key = 'h', mods = 'CMD', action = wezterm.action.Hide},
        -- Create new workspace
        {key = 'W', mods = 'LEADER|SHIFT', action = act.PromptInputLine {
            description = "(wezterm) Create new workspace:",
            action = wezterm.action_callback(function(window, pane, line)
              if line then
                window:perform_action(
                  act.SwitchToWorkspace {
                    name = line,
                  },
                  pane
                )
              end
            end
          )},
        },
        -- Switch workspace
        {key = 'w', mods = 'LEADER', action = wezterm.action_callback(
          function (win, pane)
            -- workspace のリストを作成
            local workspaces = {}
            for i, name in ipairs(wezterm.mux.get_workspace_names()) do
              table.insert(workspaces, {
                id = name,
                label = string.format("%d. %s", i, name),
              })
            end
            local current = wezterm.mux.get_active_workspace()
            -- 選択メニューを起動
            win:perform_action(act.InputSelector {
              action = wezterm.action_callback(function (_, _, id, label)
                if not id and not label then
                  wezterm.log_info "Workspace selection canceled"  -- 入力が空ならキャンセル
                else
                  win:perform_action(act.SwitchToWorkspace { name = id }, pane)  -- workspace を移動
                end
              end),
              title = "Select workspace",
              choices = workspaces,
              fuzzy = true,
              -- fuzzy_description = string.format("Select workspace: %s -> ", current), -- requires nightly build
            }, pane)
          end
        )},
    },
    default_prog = default_prog_,
}

return config;
