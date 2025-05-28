local wezterm = require 'wezterm'

local M = {}

function M.get_config()
  return {
    font_dirs = { wezterm.config_dir .. "/fonts" },
    font_size = 14,
    font = wezterm.font_with_fallback {
      "HackGenNerd Console",
      "Noto Sans CJK JP",
    },
    harfbuzz_features = { "calt=1", "clig=1", "liga=1" },
    font_rules = {
      {
        intensity = 'Normal',
        italic = true,
        font = wezterm.font_with_fallback {
          {
            family = "HackGenNerd Console",
            -- 斜体を合成させない
            style = "Normal",
            synthesis = "None",
          },
          "Noto Sans CJK JP",
        },
      },
    }
  }
end

return M

