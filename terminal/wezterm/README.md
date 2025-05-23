# WezTerm Configuration

WezTermの設定ファイル群です。機能ごとにモジュール化して管理しています。

## ディレクトリ構造

```
wezterm/
├── wezterm.lua        # メインエントリーポイント
├── config.lua         # 設定の集約
├── core/              # コア機能
│   └── events.lua     # イベントハンドラー
├── settings/          # 各種設定
│   ├── init.lua       # 設定モジュールのインデックス
│   ├── window.lua     # ウィンドウ設定
│   ├── font.lua       # フォント設定
│   └── colors.lua     # カラースキーム設定
├── key_bindings/      # キーバインディング
│   ├── init.lua       # キーバインディングの集約
│   ├── general.lua    # 一般的なキーバインディング
│   └── workspace.lua  # ワークスペース関連
└── utils/             # ユーティリティ
    └── platform.lua   # プラットフォーム判定
```

## 主な機能

- **モジュール化された設定**: 各機能が独立したファイルで管理
- **動的タブタイトル**: 現在のディレクトリ名をタブに表示
- **ワークスペース管理**: 複数のワークスペースを簡単に切り替え
- **プラットフォーム対応**: Windows/macOS/Linuxの判定
- **カスタマイズ可能なキーバインディング**: Leader keyベースの操作

## キーバインディング

### 一般操作
- `Ctrl+a`: Leader key
- `Alt+w`: ペインを閉じる
- `Cmd+h`: ウィンドウを隠す（macOSのみ）

### ワークスペース操作
- `Leader+w`: ワークスペース選択
- `Leader+Shift+w`: 新規ワークスペース作成

### タブ操作
- `Cmd+t`: 新しいタブを作成
- `Cmd+w`: タブを閉じる
- `Ctrl+Tab`: 次のタブへ
- `Ctrl+Shift+Tab`: 前のタブへ
- `Cmd+1〜8`: タブを番号で選択
- `Cmd+9`: 最後のタブを選択

## カスタマイズ

各ディレクトリ内のファイルを編集することで、設定を変更できます。
新しいモジュールを追加する場合は、`config.lua`にモジュールを追加してください。