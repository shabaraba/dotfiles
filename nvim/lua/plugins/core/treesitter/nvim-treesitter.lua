return {
  "nvim-treesitter/nvim-treesitter",
  event = "VimEnter",
  build = ":TSUpdate",
  main = 'nvim-treesitter.configs',
  opts = {
    -- 必要最小限のパーサーのみインストール
    ensure_installed = { 
      "lua", 
      "vim", 
      "vimdoc",
      "query",
      -- 実際に使用する言語のみ追加
      "javascript",
      "typescript", 
      "tsx", 
      "json",
      "yaml",
      "markdown", 
      "markdown_inline",
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- 自動インストールを無効化（パフォーマンス向上）
    auto_install = false,

    -- 不要なパーサーを除外
    ignore_install = { "phpdoc", "tree-sitter-phpdoc" },

    highlight = {
      enable = true,
      -- 大きなファイルでのハイライトを無効化
      disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
      -- 追加のvim正規表現ハイライトを無効化（パフォーマンス向上）
      additional_vim_regex_highlighting = false,
    },
    
    indent = { 
      enable = true,
      -- パフォーマンスのため、特定の言語でのみ有効化
      disable = { "yaml", "python" }
    },
    
    -- 不要なモジュールを無効化
    playground = { enable = false },
    textobjects = { enable = false },
    refactor = { enable = false },
    rainbow = { enable = false },
    context_commentstring = { enable = false },
  },
}
