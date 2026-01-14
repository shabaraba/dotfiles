# Local Plugin Configurations

このディレクトリは、**このマシン専用のプラグイン設定**を配置する場所です。

## 🎯 概要

- `.gitignore` で除外されているため、dotfilesリポジトリにはコミットされません
- lazy.nvim の標準的な `import` 機能を使用しています
- 既存プラグインの上書きや、新規プラグインの追加が可能です

## 📝 使い方

### 1. 既存プラグインの設定を上書き

例: `vibing.nvim` のRPCポートを変更

```lua
-- nvim/lua/plugins/local/vibing.lua
return {
  "shabaraba/vibing.nvim",
  opts = {
    mcp = {
      rpc_port = 9999,  -- このマシンだけポート変更
    },
  },
}
```

### 2. プラグインを無効化

```lua
-- nvim/lua/plugins/local/disable-copilot.lua
return {
  "zbirenbaum/copilot.lua",
  enabled = false,  -- このマシンでは無効化
}
```

### 3. 新規プラグインを追加

```lua
-- nvim/lua/plugins/local/my-plugin.lua
return {
  "user/my-plugin",
  config = function()
    require("my-plugin").setup()
  end,
}
```

### 4. キーマップを追加/上書き

```lua
-- nvim/lua/plugins/local/telescope-custom.lua
return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files (custom)" },
  },
}
```

## ⚙️ lazy.nvim の動作

lazy.nvim は同じプラグイン名の設定を**後から読み込んだもので上書き**します：

1. `plugins/ai/vibing.lua` を読み込み (ベース設定)
2. `plugins/local/vibing.lua` を読み込み (ローカル設定で上書き)

そのため、`plugins/local/` の設定が優先されます。

## 📂 推奨ファイル命名規則

- **上書き用**: 元のプラグインファイル名と同じ (例: `vibing.lua`)
- **無効化用**: `disable-{plugin}.lua` (例: `disable-copilot.lua`)
- **新規追加**: わかりやすい名前 (例: `my-custom-tools.lua`)

## 🚨 注意事項

- このディレクトリのファイルは `.gitignore` で除外されています
- `example-*.lua` ファイルのみGit管理されます（サンプル用）
- 他のマシンと設定を共有したい場合は、通常の `plugins/` ディレクトリを使用してください

## 📖 サンプル

`example-vibing.lua` を参考にしてください。
