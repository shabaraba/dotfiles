-- LSP最適化設定
local M = {}

-- 使用する言語に応じて読み込むLSPサーバーを動的に決定
M.get_used_servers = function()
  local used_servers = {}
  local ft = vim.bo.filetype
  
  local ft_to_server = {
    lua = "lua_ls",
    typescript = "ts_ls",
    typescriptreact = "ts_ls",
    javascript = "ts_ls",
    javascriptreact = "ts_ls",
    python = "pyright",
    rust = "rust_analyzer",
    go = "gopls",
    php = "intelephense",
    java = "jdtls",
    sh = "bashls",
    zsh = "bashls",
    bash = "bashls",
    vue = "volar",
    markdown = "markdown_oxide",
    c = "clangd",
    cpp = "clangd",
    mq5 = "clangd",
    mqh = "clangd",
  }
  
  -- 現在のファイルタイプに対応するサーバーのみを返す
  local server = ft_to_server[ft]
  if server then
    table.insert(used_servers, server)
  end
  
  -- ESLintはnull-lsで代替するため除外
  -- if ft == "javascript" or ft == "javascriptreact" or ft == "typescript" or ft == "typescriptreact" then
  --   table.insert(used_servers, "eslint")
  -- end
  
  return used_servers
end

-- サーバー設定をキャッシュ
M.server_configs = {}

M.setup_server = function(server_name)
  -- ESLintはnull-lsで代替するためスキップ
  if server_name == "eslint" then
    return
  end
  
  -- すでに設定済みの場合はスキップ
  if M.server_configs[server_name] then
    return
  end
  
  local lspconfig = require("lspconfig")
  
  -- 統一ハンドラーを使用
  local handlers = require("core.lsp.handlers")
  local on_attach = handlers.on_attach
  local capabilities = handlers.capabilities()
  
  local opts = {
    on_attach = on_attach,
    capabilities = capabilities,
  }
  
  -- 言語別設定を読み込む
  local lang_config_path = "core.lsp.languages." .. server_name:gsub("_", "-")
  local ok, lang_config = pcall(require, lang_config_path)
  if ok and lang_config.config then
    opts = vim.tbl_deep_extend("force", opts, lang_config.config)
  end
  
  -- サーバー固有の設定
  if server_name == "volar" then
    local function get_nodenv_tsdk()
      local handle = io.popen('nodenv root')
      local nodenv_root = handle:read("*a"):gsub("\n", "")
      handle:close()
      
      handle = io.popen('nodenv version-name')
      local node_version = handle:read("*a"):gsub("\n", "")
      handle:close()
      
      return nodenv_root .. '/versions/' .. node_version .. '/lib/node_modules/typescript/lib'
    end
    
    opts.init_options = {
      typescript = {
        tsdk = get_nodenv_tsdk(),
      }
    }
  elseif server_name == "eslint" then
    -- ESLintの特別な設定
    opts.on_attach = function(client, bufnr)
      -- フォーマット機能を無効化
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      
      -- 通常のon_attachも実行
      if on_attach then
        on_attach(client, bufnr)
      end
    end
    
    opts.settings = {
      eslint = {
        workingDirectory = { mode = "location" },
      },
    }
  end
  
  lspconfig[server_name].setup(opts)
  M.server_configs[server_name] = opts
end

-- 起動時に使用されるサーバーのみを初期化
M.setup = function()
  vim.api.nvim_create_autocmd({ "FileType" }, {
    callback = function(ev)
      -- 現在のバッファの情報を取得
      local bufnr = ev.buf
      local ft = ev.match
      
      -- ファイルタイプが設定されている場合のみ処理
      if ft and ft ~= "" then
        -- サーバーのキャッシュを保存する
        vim.g.lsp_servers_cache = vim.g.lsp_servers_cache or {}
        
        local servers = M.get_used_servers()
        for _, server in ipairs(servers) do
          if not M.server_configs[server] and not vim.g.lsp_servers_cache[server] then
            -- 少し遅延を入れて実行
            vim.defer_fn(function()
              M.setup_server(server)
              vim.g.lsp_servers_cache[server] = true
            end, 100)
          end
        end
      end
    end,
  })
end

return M