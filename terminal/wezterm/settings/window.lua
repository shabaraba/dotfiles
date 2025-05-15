local M = {}

function M.get_config()
  return {
    initial_rows = 30,
    initial_cols = 150,
    window_decorations = 'RESIZE',
    window_frame = {
      -- 現在はデフォルト設定を使用
    },
    window_padding = {
      left = 5,
      right = 10,
      top = 0,
      bottom = 5
    },
    window_background_image_hsb = {
      brightness = 0.3,
      hue = 1.0,
      saturation = 1.0,
    },
    window_background_opacity = 0.8,
    macos_window_background_blur = 30,
    exit_behavior = "Close",
    use_fancy_tab_bar = true,  -- よりモダンなタブバーを使用
    tab_bar_at_bottom = false, -- タブバーを上部に表示
    hide_tab_bar_if_only_one_tab = false, -- タブが1つでも表示
  }
end

return M