-- vibing.nvim のターン差分を実ファイル上に表示するための diff バックエンド。
--
-- 通常の git 差分は gitsigns が持っているので、こちらは `gen_source.none()` で
-- 参照テキストを自分からは一切計算しない。`MiniDiff.set_ref_text()` が呼ばれた
-- バッファでだけ動く = vibing.nvim 専用のレンダラとして振る舞う。
--
-- 表示は行番号の着色（gitsigns が numhl = false でサイン欄を占有しているため）。
return {
  "nvim-mini/mini.diff",
  lazy = true,
  config = function()
    local diff = require("mini.diff")
    diff.setup({
      source = diff.gen_source.none(),
      view = { style = "number" },
    })
  end,
}
