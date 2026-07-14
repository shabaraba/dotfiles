local parsers = {
  "lua",
  "vim",
  "vimdoc",
  "query",
  "javascript",
  "typescript",
  "tsx",
  "json",
  "yaml",
  "markdown",
  "markdown_inline",
}

-- indentexpr は一部言語で精度が低いため除外
local indent_disabled = { yaml = true }

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",  -- master は archived のため main（Neovim 0.12+ 対応）を使用
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = parsers,
      callback = function(args)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
        if ok and stats and stats.size > max_filesize then
          return
        end

        vim.treesitter.start()

        if not indent_disabled[args.match] then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
