local wezterm = require 'wezterm'
local act = wezterm.action

local M = {}

function M.create_workspace_bindings()
  return {
    -- Create new workspace
    {
      key = 'W',
      mods = 'LEADER|SHIFT',
      action = act.PromptInputLine {
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
        end)
      },
    },
    -- Switch workspace
    {
      key = 'w',
      mods = 'LEADER',
      action = wezterm.action_callback(
        function(win, pane)
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
            action = wezterm.action_callback(function(_, _, id, label)
              if not id and not label then
                wezterm.log_info "Workspace selection canceled"
              else
                win:perform_action(act.SwitchToWorkspace { name = id }, pane)
              end
            end),
            title = "Select workspace",
            choices = workspaces,
            fuzzy = true,
          }, pane)
        end
      )
    },
  }
end

return M