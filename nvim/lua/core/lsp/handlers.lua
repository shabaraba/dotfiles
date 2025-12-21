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
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

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