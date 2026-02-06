return {
  "folke/noice.nvim",
  -- version = "4.4.7", -- バージョン指定を削除して最新版を使用
  event = "VeryLazy",
  enabled = true, -- noice.nvimを有効化
  init = function()
    -- メッセージ履歴を保持するためのグローバル変数（永続化）
    local history_file = vim.fn.stdpath("cache") .. "/noice_message_history.json"

    -- 履歴の読み込み
    if vim.fn.filereadable(history_file) == 1 then
      local ok, content = pcall(vim.fn.readfile, history_file)
      if ok and #content > 0 then
        local ok2, decoded = pcall(vim.fn.json_decode, table.concat(content, "\n"))
        if ok2 then
          _G.noice_message_history = decoded
        end
      end
    end

    _G.noice_message_history = _G.noice_message_history or {}

    -- 履歴の保存関数
    _G.save_noice_history = function()
      local ok, encoded = pcall(vim.fn.json_encode, _G.noice_message_history)
      if ok then
        pcall(vim.fn.writefile, { encoded }, history_file)
      end
    end

    -- 終了時に保存
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        _G.save_noice_history()
      end,
    })
  end,
  config = function()
    require("noice").setup({
      cmdline = {
        enabled = true,         -- enables the Noice cmdline UI
        view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
        opts = {
          border = {
            style = "rounded",
          },
        }, -- global options for the cmdline. See section on views
        format = {
          -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
          -- view: (default is cmdline view)
          -- opts: any options passed to the view
          -- icon_hl_group: optional hl_group for the icon
          -- title: set to anything or empty string to hide
          cmdline = { pattern = "^:", icon = "", lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
          search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
          filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
          lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
          help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
          input = { view = "cmdline_input", icon = "󰥻 " }, -- Used by input()
          -- lua = false, -- to disable a format, set to `false`
        },
      },
      messages = {
        enabled = true,         -- メッセージ表示を有効化
        view = "mini",          -- default view for messages
        view_error = "mini",    -- view for errors
        view_warn = "mini",     -- view for warnings
        view_history = "split", -- view for :messages
        view_search = false,    -- search countを無効化してmsg_showを完全キャプチャ
      },
      popupmenu = {
        enabled = true,  -- enables the Noice popupmenu UI
        backend = "nui", -- backend to use to show regular cmdline completions
        -- Icons for completion item kinds (see defaults at noice.config.icons.kinds)
        kind_icons = {}, -- set to `false` to disable icons
      },
      notify = {
        enabled = true,
        view = "mini",
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        signature = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true, -- Automatically show signature help when typing trigger characters
            luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
            throttle = 50,  -- Debounce lsp signature help request by 50ms
          },
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
      routes = {
        -- null-ls/none-ls関連のログをフィルタリング
        {
          filter = {
            event = "notify",
            find = "null%-ls",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "notify",
            find = "none%-ls",
          },
          opts = { skip = true },
        },
        -- LSP関連の冗長なメッセージをフィルタリング
        {
          filter = {
            event = "notify",
            find = "eslint_d",
          },
          opts = { skip = true },
        },
        -- pile.nvim関連のログをフィルタリング
        {
          filter = {
            event = "notify",
            find = "pile",
          },
          opts = { skip = true },
        },
        -- SQL関連のログをフィルタリング
        {
          filter = {
            event = "notify",
            find = "SQL",
          },
          opts = { skip = true },
        },
        -- code_action関連のメッセージをフィルタリング
        {
          filter = {
            event = "notify",
            find = "code_action",
          },
          opts = { skip = true },
        },
        -- ✔ マークの付いたメッセージをフィルタリング
        {
          filter = {
            event = "notify",
            find = "✔",
          },
          opts = { skip = true },
        },
        -- 一般的なVimメッセージもフィルタリング
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = true },
        },
      },
      -- ビューの設定を追加
      views = {
        cmdline_popup = {
          position = {
            row = "40%",
            col = "50%",
          },
          size = {
            width = 60,
            height = "auto",
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          },
        },
        mini = {
          timeout = 5000, -- メッセージの表示時間を延長
          position = {
            row = -2,
            col = "100%",
          },
        },
        split = {
          enter = true,
        },
      },
      debug = false,
    })

    -- noice setup後にメッセージをフック
    vim.schedule(function()
      local noice_notify = vim.notify
      vim.notify = function(msg, level, opts)
        -- 履歴に追加
        table.insert(_G.noice_message_history, {
          message = tostring(msg),
          level = level or vim.log.levels.INFO,
          time = os.date("%H:%M:%S"),
        })
        -- 最新100件のみ保持
        if #_G.noice_message_history > 100 then
          table.remove(_G.noice_message_history, 1)
        end
        -- 定期的に保存（10件ごと）
        if #_G.noice_message_history % 10 == 0 and _G.save_noice_history then
          vim.schedule(function()
            _G.save_noice_history()
          end)
        end
        -- noiceのnotifyを呼び出し
        return noice_notify(msg, level, opts)
      end

    end)

    -- :set結果を履歴に残すラッパーコマンド
    local function set_with_history(option)
      if option:match("%?$") then
        -- クエリモード
        local opt_name = option:sub(1, -2)
        local ok, value = pcall(vim.api.nvim_get_option_value, opt_name, {})
        if ok then
          local message = string.format("%s=%s", opt_name, vim.inspect(value))
          vim.notify(message, vim.log.levels.INFO)
        else
          vim.notify("Invalid option: " .. opt_name, vim.log.levels.ERROR)
        end
      else
        -- 設定モード
        vim.cmd("set " .. option)
        vim.notify("Set: " .. option, vim.log.levels.INFO)
      end
    end

    vim.api.nvim_create_user_command("Set", function(opts)
      set_with_history(opts.args)
    end, { nargs = 1, complete = "option" })

    -- 通常のsetコマンドをフックする代わりに、便利なショートカットを提供
    vim.api.nvim_create_user_command("S", function(opts)
      set_with_history(opts.args)
    end, { nargs = 1, complete = "option" })

    -- 履歴表示コマンド
    vim.api.nvim_create_user_command("MessageHistory", function()
      local lines = {}
      local history_file = vim.fn.stdpath("cache") .. "/noice_message_history.json"

      -- ヘッダー情報
      table.insert(lines, "Message History (Total: " .. #_G.noice_message_history .. " entries)")
      table.insert(lines, "Saved to: " .. history_file)
      table.insert(lines, string.rep("-", 80))
      table.insert(lines, "")

      for i = #_G.noice_message_history, 1, -1 do
        local entry = _G.noice_message_history[i]
        local level_name = ({ "ERROR", "WARN", "INFO", "DEBUG" })[entry.level or 3] or "INFO"
        local header = string.format("[%s] %s:", entry.time, level_name)

        -- メッセージを行ごとに分割
        for line in entry.message:gmatch("[^\r\n]+") do
          table.insert(lines, header .. " " .. line)
          header = "     " .. string.rep(" ", #level_name) -- 2行目以降はインデント
        end
      end

      if #_G.noice_message_history == 0 then
        vim.notify("No message history", vim.log.levels.INFO)
        return
      end

      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
      vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
      vim.api.nvim_buf_set_option(buf, "modifiable", false)
      vim.api.nvim_buf_set_name(buf, "MessageHistory")

      vim.cmd("split")
      vim.api.nvim_win_set_buf(0, buf)
    end, {})
  end,
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify",
  }
}
