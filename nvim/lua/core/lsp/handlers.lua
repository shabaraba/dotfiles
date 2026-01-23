-- LSP ハンドラーとキーマッピングの統一管理
local M = {}

-- 共通のon_attach関数
M.on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  
  -- ナビゲーション
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts) -- noice.nvimでauto_openを有効にしたため削除
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
  
  -- ワークスペース
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  
  -- コードアクション
  vim.keymap.set({ 'n', 'v' }, '<leader>ca', function()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    if #clients > 0 then
      vim.lsp.buf.code_action()
    else
      vim.notify("No LSP server attached", vim.log.levels.WARN)
    end
  end, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  -- vim.keymap.set('n', '<leader>f', function()
  --   vim.lsp.buf.format { async = true }
  -- end, opts) -- Formatコマンドを使用するため削除
  
  -- 特定のクライアント設定
  if client.name == "tsserver" then
    -- TypeScriptはフォーマットを無効化（Prettierを使用）
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  elseif client.name == "eslint" then
    -- ESLintもフォーマットを無効化
    client.server_capabilities.documentFormattingProvider = false
  end
  
  -- インレイヒントの設定（対応している場合）
  if client.server_capabilities.inlayHintProvider then
    -- Neovim 0.10+ の新しいAPI
    vim.lsp.inlay_hint.enable(true)
  end
  
  -- documentHighlightの設定
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

-- Capabilities設定
M.capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- cmp_nvim_lsp がロードされている場合は拡張
  local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end

  -- スニペットサポート
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  -- フォールディング
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
  }

  return capabilities
end

-- LspAttach自動コマンドの設定
M.setup = function()
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
      M.on_attach(vim.lsp.get_client_by_id(ev.data.client_id), ev.buf)
    end,
  })

  -- LSP終了処理の設定
  M.setup_exit_handlers()

  -- 診断設定の読み込み
  require("core.lsp.diagnostic").setup()
  require("core.lsp.diagnostic").setup_keymaps()

  -- :LspInfo代替コマンドの作成
  vim.api.nvim_create_user_command('LspInfo', function()
    M.show_lsp_info()
  end, {})
end

-- LSP情報の表示（:LspInfo代替）
M.show_lsp_info = function()
  local buf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = buf })
  local ft = vim.bo[buf].filetype

  local lines = {}
  table.insert(lines, "Language client log: " .. vim.lsp.get_log_path())
  table.insert(lines, "Detected filetype: " .. ft)
  table.insert(lines, "")

  if #clients == 0 then
    table.insert(lines, "No LSP clients attached to this buffer")
  else
    table.insert(lines, string.format("%d client(s) attached to this buffer:", #clients))
    table.insert(lines, "")

    for _, client in ipairs(clients) do
      table.insert(lines, string.format("Client: %s (id: %d)", client.name, client.id))
      table.insert(lines, string.format("  Root directory: %s", client.root_dir or "N/A"))
      table.insert(lines, string.format("  Filetypes: %s", table.concat(client.config.filetypes or {}, ", ")))
      table.insert(lines, string.format("  Autostart: true"))
      table.insert(lines, string.format("  Command: %s", table.concat(client.config.cmd or {}, " ")))

      local attached_bufs = vim.lsp.get_buffers_by_client_id(client.id)
      table.insert(lines, string.format("  Attached buffers: %d", #attached_bufs))
      table.insert(lines, "")
    end
  end

  local all_clients = vim.lsp.get_clients()
  if #all_clients > #clients then
    table.insert(lines, string.format("Other active clients: %d", #all_clients - #clients))
    for _, client in ipairs(all_clients) do
      local is_attached = false
      for _, attached_client in ipairs(clients) do
        if client.id == attached_client.id then
          is_attached = true
          break
        end
      end
      if not is_attached then
        table.insert(lines, string.format("  - %s (id: %d)", client.name, client.id))
      end
    end
  end

  local buf_info = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf_info, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf_info, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf_info, 'buftype', 'nofile')

  local win_info = vim.api.nvim_open_win(buf_info, true, {
    relative = 'editor',
    width = math.floor(vim.o.columns * 0.8),
    height = math.floor(vim.o.lines * 0.8),
    row = math.floor(vim.o.lines * 0.1),
    col = math.floor(vim.o.columns * 0.1),
    style = 'minimal',
    border = 'rounded',
    title = ' LSP Information ',
    title_pos = 'center',
  })

  vim.api.nvim_buf_set_keymap(buf_info, 'n', 'q', ':close<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf_info, 'n', '<Esc>', ':close<CR>', { noremap = true, silent = true })
end

-- LSP終了処理の設定
M.setup_exit_handlers = function()
  -- Vim終了前にLSPクライアントを適切に停止
  vim.api.nvim_create_autocmd("VimLeavePre", {
    pattern = "*",
    callback = function()
      -- アクティブなLSPクライアントを取得して停止
      local clients = vim.lsp.get_clients()
      for _, client in pairs(clients) do
        if client and client.is_stopped ~= nil and not client.is_stopped() then
          vim.lsp.stop_client(client.id, true) -- force stop
        end
      end
    end,
    desc = "Stop LSP clients before Vim exits"
  })
  
  -- バッファが削除されるときの処理
  vim.api.nvim_create_autocmd("BufDelete", {
    pattern = "*",
    callback = function(ev)
      -- そのバッファに関連するLSPクライアントをチェック
      local clients = vim.lsp.get_clients({ bufnr = ev.buf })
      for _, client in pairs(clients) do
        local attached_buffers = vim.lsp.get_buffers_by_client_id(client.id)
        -- 他にアタッチされているバッファがない場合は停止を検討
        if #attached_buffers <= 1 then
          -- 即座に停止せず、少し待ってから判断（他の操作による再アタッチを考慮）
          vim.defer_fn(function()
            local current_buffers = vim.lsp.get_buffers_by_client_id(client.id)
            if #current_buffers == 0 and not client.is_stopped() then
              vim.lsp.stop_client(client.id)
            end
          end, 100)
        end
      end
    end,
    desc = "Clean up LSP clients when buffer is deleted"
  })
end

return M