-- TimeKiller.nvim: Neovimバッファ内の暇つぶしミニゲーム集 (Snake / 2048)
-- ~/workspace/nvim-plugins/TimeKiller.nvim (dev.pathのローカルコピーを使用)
return {
  "shabaraba/TimeKiller.nvim",
  dev = true,
  main = "timekiller",
  cmd = { "TimeKillerSnake", "TimeKiller2048" },
  opts = {
    layout = "vsplit", -- float | split | vsplit | tab
  },
}
