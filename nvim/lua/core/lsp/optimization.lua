-- LSP最適化設定 (Neovim 0.11+ API)
local M = {}

-- ファイルタイプとLSPサーバーのマッピング
local ft_to_server = {
  lua = { "lua_ls" },
  typescript = { "vtsls", "eslint" },
  typescriptreact = { "vtsls", "eslint" },
  javascript = { "vtsls", "eslint" },
  javascriptreact = { "vtsls", "eslint" },
  python = { "pyright", "ruff" },
  rust = { "rust_analyzer" },
  go = { "gopls" },
  php = { "intelephense" },
  sh = { "bashls" },
  zsh = { "bashls" },
  bash = { "bashls" },
  vue = { "vtsls" },  -- vue_ls は nvim-lspconfig.lua で有効化済み
  markdown = { "markdown_oxide" },
  c = { "clangd" },
  cpp = { "clangd" },
  mq5 = { "clangd" },
  mqh = { "clangd" },
}

-- 設定済みサーバーのキャッシュ
M.configured_servers = {}

-- サーバー設定を構築
local function build_server_config(server_name)
  local handlers = require("core.lsp.handlers")
  local opts = {
    on_attach = handlers.on_attach,
    capabilities = handlers.capabilities(),
  }

  -- 言語別設定を読み込む
  local lang_config_path = "core.lsp.languages." .. server_name:gsub("_", "-")
  local ok, lang_config = pcall(require, lang_config_path)
  if ok and lang_config.config then
    opts = vim.tbl_deep_extend("force", opts, lang_config.config)
  end

  -- サーバー固有の設定
  if server_name == "vtsls" then
    local mason_path = vim.fn.stdpath("data") .. "/mason"
    local function get_mise_node_path()
      local node_paths = {
        vim.fn.expand("~/.local/share/mise/installs/node/22.19.0/bin/node"),
        vim.fn.expand("~/.local/share/mise/installs/node/latest/bin/node"),
      }
      for _, path in ipairs(node_paths) do
        if vim.fn.filereadable(path) == 1 then
          return path
        end
      end
      return "node"
    end
    opts.cmd = {
      get_mise_node_path(),
      mason_path .. "/packages/vtsls/node_modules/@vtsls/language-server/bin/vtsls.js",
      "--stdio"
    }
  elseif server_name == "eslint" then
    opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
      workingDirectory = { mode = "auto" }
    })
  end

  return opts
end

-- サーバーを設定して有効化
M.setup_server = function(server_name)
  if M.configured_servers[server_name] then
    return
  end

  -- jdtls は nvim-jdtls プラグインで処理
  if server_name == "jdtls" then
    M.configured_servers[server_name] = true
    return
  end

  local opts = build_server_config(server_name)

  -- 新しいAPI: vim.lsp.config + vim.lsp.enable
  vim.lsp.config(server_name, opts)
  vim.lsp.enable(server_name)

  M.configured_servers[server_name] = true
end

-- FileType autocmd でサーバーを動的に起動
M.setup = function()
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
      local ft = ev.match
      if not ft or ft == "" then
        return
      end

      local servers = ft_to_server[ft]
      if not servers then
        return
      end

      for _, server in ipairs(servers) do
        if not M.configured_servers[server] then
          vim.defer_fn(function()
            M.setup_server(server)
          end, 50)
        end
      end
    end,
  })
end

return M
