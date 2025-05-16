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
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
  
  -- ワークスペース
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  
  -- コードアクション
  vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>f', function()
    vim.lsp.buf.format { async = true }
  end, opts)
  
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
  
  -- セマンティックトークン
  capabilities.textDocument.semanticHighlighting = true
  
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
  
  -- 診断設定の読み込み
  require("core.lsp.diagnostic").setup()
  require("core.lsp.diagnostic").setup_keymaps()
end

return M