-- LSP サーバーの root directory パターン設定
local M = {}

M.patterns = {
  -- JavaScript/TypeScript
  tsserver = {
    "package.json",
    "tsconfig.json",
    "jsconfig.json",
    ".git",
    "node_modules",
  },
  
  -- Python
  pyright = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".git",
  },
  
  -- Rust
  rust_analyzer = {
    "Cargo.toml",
    "rust-project.json",
    ".git",
  },
  
  -- Lua
  lua_ls = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
  },
  
  -- Go
  gopls = {
    "go.mod",
    "go.work",
    ".git",
  },
  
  -- PHP
  intelephense = {
    "composer.json",
    ".git",
  },
  
  -- Vue (vue_ls は新しいAPIで自動設定される)
  
  -- Default pattern
  default = {
    ".git",
    "Makefile",
    "package.json",
  }
}

-- root_dir 関数を生成
M.get_root_dir = function(server_name)
  local util = require("lspconfig.util")
  local patterns = M.patterns[server_name] or M.patterns.default
  
  return function(fname)
    -- ファイル名が空の場合の処理
    if not fname or fname == "" then
      return vim.fn.getcwd()
    end
    
    -- パターンマッチング
    local root = util.root_pattern(unpack(patterns))(fname)
    if root then
      return root
    end
    
    -- Git祖先を探す
    root = util.find_git_ancestor(fname)
    if root then
      return root
    end
    
    -- 最終フォールバック
    return util.path.dirname(fname)
  end
end

return M