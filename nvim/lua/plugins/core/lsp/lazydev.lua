-- lua_ls にNeovim本体とプラグインの型定義を渡す。
-- これにより `---@type Vibing.Config` を付けたテーブル内で
-- フィールド名とenum文字列（"right"|"left"等）が補完される
return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
}
