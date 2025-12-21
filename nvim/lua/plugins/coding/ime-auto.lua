return {
  "shabaraba/ime-auto.nvim",
  dev = true,  -- ~/workspaces/nvim-plugins/ime-auto.nvim を使用
  event = { "InsertEnter", "CmdlineEnter" },
  config = function()
    require("ime-auto").setup({
      escape_sequence = "ｋｊ",
      escape_timeout = 200,
      os = "auto",
      ime_method = "builtin",
      debug = false,
    })
  end,
}
