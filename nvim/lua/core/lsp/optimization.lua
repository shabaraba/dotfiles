-- LSP最適化設定
local M = {}

-- 使用する言語に応じて読み込むLSPサーバーを動的に決定
M.get_used_servers = function()
  local used_servers = {}
  local ft = vim.bo.filetype
  
  local ft_to_server = {
    lua = "lua_ls",
    typescript = "vtsls",  -- vtslsのみ
    typescriptreact = "vtsls",
    javascript = "vtsls",
    javascriptreact = "vtsls",
    python = "pyright",
    rust = "rust_analyzer",
    go = "gopls",
    php = "intelephense",
    java = "jdtls",
    sh = "bashls",
    zsh = "bashls",
    bash = "bashls",
    vue = "vue_ls",
    markdown = "markdown_oxide",
    c = "clangd",
    cpp = "clangd",
    mq5 = "clangd",
    mqh = "clangd",
  }
  
  -- 現在のファイルタイプに対応するサーバーのみを返す
  local servers = ft_to_server[ft]
  if servers then
    if type(servers) == "table" then
      for _, server in ipairs(servers) do
        table.insert(used_servers, server)
      end
    else
      table.insert(used_servers, servers)
    end
  end
  
  
  return used_servers
end

-- サーバー設定をキャッシュ
M.server_configs = {}

M.setup_server = function(server_name)
  
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
  if server_name == "vue_ls" then
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
