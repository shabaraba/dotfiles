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
    -- java = "jdtls",  -- nvim-jdtlsプラグインで処理
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

  -- lspconfigを使用(nvim-0.11の警告は既知の問題)
  -- TODO(#20): nvim-lspconfig v3.0.0リリース後に vim.lsp.config へ移行
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
  if server_name == "vtsls" then
    -- vtslsの実行コマンドとroot_dirを設定
    local mason_path = vim.fn.stdpath("data") .. "/mason"
    -- プロジェクト対応のnode実行ファイルを動的に探す
    local function get_project_node_path()
      local cwd = vim.fn.getcwd()
      
      -- 1. プロジェクトのmise設定を確認
      local function get_mise_project_node()
        -- .mise.toml か .tool-versions を確認
        local mise_files = { ".mise.toml", ".tool-versions" }
        for _, file in ipairs(mise_files) do
          local mise_file = cwd .. "/" .. file
          if vim.fn.filereadable(mise_file) == 1 then
            -- mise current nodeでプロジェクトのnodeバージョンを取得
            local handle = io.popen("cd " .. vim.fn.shellescape(cwd) .. " && mise current node 2>/dev/null")
            if handle then
              local version = handle:read("*a"):gsub("%s+", "")
              handle:close()
              if version and version ~= "" then
                local node_path = vim.fn.expand("~/.local/share/mise/installs/node/" .. version .. "/bin/node")
                if vim.fn.filereadable(node_path) == 1 then
                  return node_path
                end
              end
            end
          end
        end
        return nil
      end
      
      -- 2. プロジェクト固有のnode確認
      local project_node = get_mise_project_node()
      if project_node then
        return project_node
      end
      
      -- 3. フォールバック: システムのNode.jsのみ
      local fallback_paths = {
        "/opt/homebrew/bin/node",
        "/usr/local/bin/node", 
        "/usr/bin/node",
      }
      
      for _, path in ipairs(fallback_paths) do
        if vim.fn.filereadable(path) == 1 then
          return path
        end
      end
      
      -- 最後のフォールバック
      return "node"
    end
    local node_path = get_project_node_path()
    local vtsls_path = mason_path .. "/packages/vtsls/node_modules/@vtsls/language-server/bin/vtsls.js"
    opts.cmd = { node_path, vtsls_path, "--stdio" }
    opts.root_dir = require('lspconfig.util').root_pattern('package.json', 'tsconfig.json', 'jsconfig.json', '.git')
  elseif server_name == "jdtls" then
    -- jdtlsは nvim-jdtls プラグインで処理するためスキップ
    M.server_configs[server_name] = true
    return
  elseif server_name == "vue_ls" then
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
