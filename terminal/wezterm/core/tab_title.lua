local wezterm = require 'wezterm'

local M = {}

-- ディレクトリ名を取得する関数
local function get_directory_name(pane)
  local cwd = pane:get_current_working_dir()
  if cwd then
    -- ファイルURLから実際のパスを抽出
    local path = cwd:match("^file://(.+)") or cwd
    -- ホームディレクトリを~に置換
    path = path:gsub("^" .. wezterm.home_dir, "~")
    -- 最後のディレクトリ名を取得
    local dir_name = path:match("([^/]+)$") or path
    return dir_name
  end
  return "?"
end

function M.setup()
  -- タブのタイトルをフォーマットする
  wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    local pane = tab.active_pane
    local title = get_directory_name(pane)
    
    -- アクティブなプロセス名も取得
    local process_name = pane.foreground_process_name
    if process_name then
      process_name = process_name:match("([^/]+)$")
      -- 一般的なシェル名以外の場合は表示
      if process_name ~= "zsh" and process_name ~= "bash" and process_name ~= "fish" then
        title = process_name .. " | " .. title
      end
    end
    
    -- タブ番号を追加
    local tab_index = tab.tab_index + 1
    title = string.format("%d: %s", tab_index, title)
    
    -- タブがアクティブな場合は強調表示
    local edge_background = '#353535'
    local edge_foreground = '#cccccc'
    
    if tab.is_active then
      return {
        { Background = { Color = edge_background } },
        { Foreground = { Color = edge_foreground } },
        { Text = "" },
        { Background = { Color = '#2b2042' } },
        { Foreground = { Color = '#ffffff' } },
        { Text = " " .. title .. " " },
        { Background = { Color = edge_background } },
        { Foreground = { Color = '#2b2042' } },
        { Text = "" },
      }
    end
    
    return {
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = "" },
      { Background = { Color = '#1b1f2f' } },
      { Foreground = { Color = '#888888' } },
      { Text = " " .. title .. " " },
      { Background = { Color = edge_background } },
      { Foreground = { Color = '#1b1f2f' } },
      { Text = "" },
    }
  end)
  
  -- ペインのタイトルも更新
  wezterm.on('update-status', function(window, pane)
    local workspace = window:active_workspace()
    local dir_name = get_directory_name(pane)
    
    -- ステータスバーにワークスペースとディレクトリを表示
    window:set_left_status(wezterm.format({
      { Text = ' ' .. workspace .. ' | ' .. dir_name .. ' ' }
    }))
  end)
end

return M