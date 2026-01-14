return {
  "terryma/vim-expand-region",
  keys = {
    { "v", "<Plug>(expand_region_expand)", mode = "v", desc = "Expand region" },
    { "V", "<Plug>(expand_region_shrink)", mode = "v", desc = "Shrink region" },
  },
  config = function()
    -- 範囲を広げる順番を細かく定義できる
    vim.g.expand_region_text_objects = {
      ["iw"] = 0, -- 単語
      ['i"'] = 1, -- ダブルクォート内
      ["i'"] = 1, -- シングルクォート内
      ["i("] = 1, -- カッコ内
      ["i["] = 1, -- 角カッコ内
      ["i{"] = 1, -- 波カッコ内
      ["it"] = 1, -- HTMLタグ内
      ["ib"] = 1, -- ブロック
      ["il"] = 0, -- 行（ここを追加すると細かくなる）
      ["ip"] = 0, -- 段落
    }
  end,
}
