return {
  "shabaraba/ime-auto.nvim",
  dev = true,
  event = { "InsertEnter", "CmdlineEnter" },
  config = function()
    require("ime-auto").setup({
      escape_sequence = "ｋｊ",
    })
  end,
}
