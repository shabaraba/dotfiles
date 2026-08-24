-- セッション復元から外すパス。
-- mason 配下(LSP が定義ジャンプで開いた lib.dom.d.ts 等)を復元すると
-- そこを root とする余計な LSP インスタンスが立つため除外する。
local function should_skip_session_path(path)
  if not path or path == "" then
    return true
  end

  local normalized = path:gsub("\\", "/")
  if normalized:find("/%.local/share/nvim/mason/") then
    return true
  end

  local stat = (vim.uv or vim.loop).fs_stat(path)
  return stat ~= nil and stat.size > 512 * 1024
end

local function patch_session_restore_filter()
  local session_store = require("pile.storage.session_store")
  if session_store._dotfiles_restore_filter_patched then
    return
  end

  local original_get_session = session_store.get_session

  session_store.get_session = function(name)
    local session = original_get_session(name)
    if not session then
      return session
    end

    local filtered = vim.deepcopy(session)
    filtered.buffers = vim.tbl_filter(function(buf)
      return not should_skip_session_path(buf.path)
    end, filtered.buffers or {})
    filtered.layout = vim.tbl_filter(function(win)
      return not should_skip_session_path(win.bufpath)
    end, filtered.layout or {})
    return filtered
  end

  session_store.get_current_session = function()
    return session_store.get_session(session_store.get_current_session_name())
  end

  session_store._dotfiles_restore_filter_patched = true
end

return {
  {
    "shabaraba/pile.nvim",
    lazy = false, -- 起動時にロード
    dev = true,
    keys = require("mappings").pile,
    config = function(_, opts)
      patch_session_restore_filter()
      require("pile").setup(opts)
    end,
    opts = {
      debug = {
        enabled = false, -- デバッグを無効化
        level = "error", -- エラーレベルのみ
        file_logging = true,
        sqlite = {
          trace_init = false,
          trace_query = false,
        }
      },
      session = {
        auto_save = true,      -- 終了時に自動保存
        auto_restore = true,   -- 起動時に自動復元
        preserve_order = true, -- 並び順を保持
      },
    },
  },
}
