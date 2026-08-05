# Local Plugin Overrides

このディレクトリは、**このマシン専用のプラグインURL上書き設定**を配置する場所です。

## 🎯 概要

- `.gitignore` で除外されているため、dotfilesリポジトリにはコミットされません
- `core/plugins/init.lua` の `M.require(name)` が、ここにある `.lua` ファイルを走査し、
  `core/plugins.lua`（レジストリ）より優先して使います
- 主な用途: プラグインをローカルの作業クローンに向けて動作確認する（GitHubへpushせずに済む）

## 📝 使い方

### ローカルの作業クローンを使う

例: `~/workspace/private/claude-usage.wezterm` で開発中のコードを使う

```lua
-- core/plugins/local/claude-usage.lua
return {
  name = 'claude-usage.wezterm',
  url = 'file:///Users/YOUR_NAME/workspace/private/claude-usage.wezterm',
}
```

コード変更を反映するには `wezterm.plugin.update_all()` の実行が必要です（保存だけでは
WezTermのランタイムディレクトリに同期されません）。実行後 `CTRL+SHIFT+R` などで
設定をリロードしてください。

## 📂 ファイル命名規則

- ファイル名は自由ですが、`name` フィールドが `core/plugins/init.lua` の
  レジストリキーと一致する必要があります
- `init.lua` と `*.lua.example` は上書き対象として読み込まれません（サンプル/プレースホルダのため）

## 🚨 注意事項

- このディレクトリのファイルは `.gitignore` で除外されています
- `init.lua`・`README.md`・`*.lua.example` のみGit管理されます
- 他のマシンと設定を共有したい場合は、通常の `core/plugins/init.lua` のレジストリを使用してください

## 📖 サンプル

`claude-usage.lua.example` を参考にしてください。
