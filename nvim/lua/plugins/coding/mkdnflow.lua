vim.g.copilot_assume_mapped = true -- copilotのキーバインドを優先する
return {
  'jakewvincent/mkdnflow.nvim',
  ft = { 'md', 'markdown' }, -- 対象のファイルタイプを指定
  opts = {
    modules = {
      bib = true,
      buffers = true,
      conceal = true,
      cursor = true,
      folds = false,
      foldtext = false,
      links = true,
      lists = true,
      maps = true,
      paths = true,
      tables = true,
      yaml = false,
      cmp = false
    },
    filetypes = { md = true, rmd = true, markdown = true },
    lists = {
      auto_indent = true,        -- リストの自動インデント
      auto_new_list_item = true, -- 新しいリストアイテムを自動追加
    },
  },
}
