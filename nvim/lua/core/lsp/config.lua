-- Neovim 0.11+ vim.lsp.config API を使用したLSP設定
-- 参考: https://neovim.io/doc/user/lsp.html
-- 参考: https://xnacly.me/posts/2025/neovim-lsp-changes/
local M = {}

-- プロジェクト固有のNode.jsパスを取得（vtsls用）
local function get_project_node_path()
  local cwd = vim.fn.getcwd()

  -- 1. プロジェクトのmise設定を確認
  local function get_mise_project_node()
    local mise_files = { ".mise.toml", ".tool-versions" }
    for _, file in ipairs(mise_files) do
      local mise_file = cwd .. "/" .. file
      if vim.fn.filereadable(mise_file) == 1 then
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

  local project_node = get_mise_project_node()
  if project_node then
    return project_node
  end

  -- フォールバック: システムのNode.js
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

  return "node"
end

-- グローバル設定
M.setup_global_config = function()
  local handlers = require("core.lsp.handlers")

  -- すべてのLSPサーバーに共通する設定
  vim.lsp.config('*', {
    capabilities = handlers.capabilities(),
  })
end

-- 各サーバーの設定
M.define_server_configs = function()
  local handlers = require("core.lsp.handlers")
  local capabilities = handlers.capabilities()

  -- vtsls (TypeScript/JavaScript)
  local mason_path = vim.fn.stdpath("data") .. "/mason"
  local node_path = get_project_node_path()
  local vtsls_path = mason_path .. "/packages/vtsls/node_modules/@vtsls/language-server/bin/vtsls.js"

  vim.lsp.config.vtsls = {
    cmd = { node_path, vtsls_path, "--stdio" },
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
    root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
    capabilities = capabilities,
  }

  -- lua_ls
  vim.lsp.config.lua_ls = {
    cmd = { mason_path .. "/bin/lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", "stylua.toml", ".git" },
    capabilities = capabilities,
  }

  -- pyright
  vim.lsp.config.pyright = {
    cmd = { mason_path .. "/bin/pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "requirements.txt", "Pipfile", ".git" },
    capabilities = capabilities,
  }

  -- rust_analyzer
  vim.lsp.config.rust_analyzer = {
    cmd = { mason_path .. "/bin/rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", "rust-project.json", ".git" },
    capabilities = capabilities,
  }

  -- gopls
  vim.lsp.config.gopls = {
    cmd = { mason_path .. "/bin/gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.mod", "go.work", ".git" },
    capabilities = capabilities,
  }

  -- intelephense (PHP)
  vim.lsp.config.intelephense = {
    cmd = { mason_path .. "/bin/intelephense", "--stdio" },
    filetypes = { "php" },
    root_markers = { "composer.json", ".git" },
    capabilities = capabilities,
  }

  -- bashls
  vim.lsp.config.bashls = {
    cmd = { mason_path .. "/bin/bash-language-server", "start" },
    filetypes = { "sh", "bash", "zsh" },
    root_markers = { ".git" },
    capabilities = capabilities,
  }

  -- clangd (C/C++/MQL)
  vim.lsp.config.clangd = {
    cmd = { mason_path .. "/bin/clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "mq5", "mqh" },
    root_markers = { ".clangd", ".clang-format", "compile_commands.json", ".git" },
    capabilities = capabilities,
  }

  -- marksman (Markdown LSP)
  vim.lsp.config.marksman = {
    cmd = { mason_path .. "/bin/marksman", "server" },
    filetypes = { "markdown", "markdown.mdx" },
    root_markers = { ".marksman.toml", ".git" },
    capabilities = capabilities,
  }

  -- eslint
  vim.lsp.config.eslint = {
    cmd = { mason_path .. "/bin/vscode-eslint-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
    root_markers = { ".eslintrc", ".eslintrc.js", ".eslintrc.json", "package.json", ".git" },
    capabilities = capabilities,
  }
end

-- サーバーを有効化
M.enable_servers = function()
  -- 利用可能なすべてのサーバーを有効化
  local servers = {
    "vtsls",
    "lua_ls",
    "pyright",
    "rust_analyzer",
    "gopls",
    "intelephense",
    "bashls",
    "clangd",
    "marksman",
    "eslint",
  }

  for _, server in ipairs(servers) do
    vim.lsp.enable(server)
  end
end

-- メインセットアップ関数
M.setup = function()
  -- グローバル設定
  M.setup_global_config()

  -- 各サーバーの設定
  M.define_server_configs()

  -- サーバーを有効化
  M.enable_servers()
end

return M
