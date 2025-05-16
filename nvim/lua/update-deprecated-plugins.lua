-- 廃止予定APIを使用しているプラグインを更新するスクリプト
return function()
  -- Lazy.nvimを使用してプラグインを更新
  local plugins_to_update = {
    "lspsaga.nvim",
    "nvim-colorizer.lua",
    "alpha-nvim"
  }
  
  print("以下のプラグインを更新します：")
  for _, plugin in ipairs(plugins_to_update) do
    print("- " .. plugin)
  end
  
  -- すべてのプラグインを更新
  vim.cmd("Lazy update")
  
  print("\n更新が完了したら、Neovimを再起動してください。")
  print("それでも警告が消えない場合は、プラグインの設定を確認する必要があります。")
end