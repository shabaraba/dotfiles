-- 【通知システム一元管理】
-- このファイルですべてのvim.notify設定を管理します
-- 他のファイルでvim.notifyを上書きしないこと！

return {
  "rcarriga/nvim-notify",
  lazy = true,
  opts = {
    background_colour = "#000000",
    fps = 30,
    icons = {
      DEBUG = "",
      ERROR = "",
      INFO = "",
      TRACE = "✎",
      WARN = "",
    },
    level = "WARN", -- ERRORとWARNのみ表示（INFOとDEBUGを非表示）
    minimum_width = 50,
    render = "compact", -- default, minimal, simple, compact
    stages = "fade_in_slide_out",
    timeout = 3000,
    top_down = false,
  },
  config = function(_, opts)
    local notify = require("notify")
    notify.setup(opts)
    
    -- 【一元管理】vim.notifyをフィルタリング付きで設定
    vim.notify = function(msg, level, opts_param)
      -- 通知を抑制するパターンリスト
      local filter_patterns = {
        "null%-ls",      -- null-ls関連
        "none%-ls",      -- none-ls関連  
        "eslint_d",      -- eslint_d関連
        "eslint%-d",     -- eslint-d（ハイフン）関連
        "pile",          -- pile.nvim関連
        "SQL",           -- SQLクエリ関連
        "code_action",   -- コードアクション関連
        "code%-action",  -- code-action（ハイフン）関連
        "✔",             -- チェックマーク付きメッセージ
        "diagnostic",    -- 診断関連の冗長なメッセージ
        "attached",      -- LSP接続メッセージ
        "lsp",           -- 一般的なLSPメッセージ
        "LSP",           -- 大文字のLSPメッセージ
      }
      
      -- メッセージが文字列の場合のみフィルタリング実行
      if type(msg) == "string" then
        -- 大小文字を区別しない検索でパターンマッチング
        local msg_lower = msg:lower()
        for _, pattern in ipairs(filter_patterns) do
          if msg:find(pattern) or msg_lower:find(pattern:lower()) then
            return -- 通知を無視
          end
        end
        
        -- 追加の直接マッチング（確実にブロック）
        if msg_lower:find("eslint") or msg_lower:find("null") or msg_lower:find("none") then
          return -- 通知を無視
        end
      end
      
      -- フィルタリングを通過したメッセージのみ表示
      notify(msg, level, opts_param)
    end
    
    -- Telescope拡張を読み込む
    require("telescope").load_extension("notify")
    
    -- キーマッピング
    -- vim.keymap.set("n", "<leader>fn", function()
    --   require("telescope").extensions.notify.notify()
    -- end, { desc = "Show notification history" })
    
    -- 通知履歴をクリアするコマンド
    vim.api.nvim_create_user_command("NotifyClear", function()
      notify.dismiss({ silent = true, pending = true })
    end, {})
  end,
}
